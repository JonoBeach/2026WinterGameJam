extends CharacterBody2D
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
@onready var player = get_parent().get_node("Player")
@onready var enemy_sprite = $EnemySprite
@onready var hit_area = $HitArea
@onready var spots = get_parent().get_node("enemypositions").get_used_cells()

var attackpos
var movei = 0
var move_list = []
var rng = RandomNumberGenerator.new()
var direction
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""
var attacking_tiles
var dead = false

func _ready():
	Global.enemy_move.connect(do_attack)
	Global.enemy_calculate_move.connect(calculate_enemy_move)
	Global.enemy_walk_start.connect(enemy_move)
	Global.occupied.append(position)

func _physics_process(_delta):
	if !dead:
		if !player == null:
			if position.y <= player.position.y:
				z_index = -1
			else:
				z_index = 1
		if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
			velocity = Vector2.ZERO
			direction = ""
			set_position(end)
			$CollisionShape2D.set_deferred("disabled",false)
			enemy_move()
		if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
			velocity = Vector2.ZERO
			pushdirection = ""
			set_position(pushend)
			$CollisionShape2D.set_deferred("disabled",false)
		if $Enemy_overlap.monitoring:
			if $Enemy_overlap.get_overlapping_areas().size()>0:
				$Enemy_overlap.get_overlapping_areas()[0].get_parent().killed(Vector2(0,0))
				$Enemy_overlap/CollisionShape2D.disabled = true
		move_and_slide()

func attack_indicate():
	attacking_tiles = attack_movement_patterns.enemy_attack_pattern()
	pass
	
func do_attack():
	if !dead:
		$Move_indicator.hide()
		if (attackpos in Global.spots):
			$EnemySprite.play("Attack")
			await get_tree().create_timer(.35).timeout
			$Swordslash.play()
			hit_area.set_deferred("monitoring", true)
			$HitArea/EnemAttack.play("attack")
			match attackpos-get_position():
				Vector2(0,120):
					$HitArea/EnemAttack.flip_v = true
				Vector2(-120,0):
					$HitArea/EnemAttack.flip_h = true
					$HitArea/EnemAttack.rotation_degrees = -90
				Vector2(120,0):
					$HitArea/EnemAttack.rotation_degrees = 90
			await get_tree().create_timer(1).timeout
			hit_area.set_deferred("monitoring", false)
			$HitArea.hide()
		Global.enemy_attack_finish.emit()

		
		Global.occupied.erase(position)
		#enemy_move()
	
func move_indicate():
	pass

func calculate_enemy_move():
	var attacks = attack_movement_patterns.enemy_movement_location(position)
	if attacks.size()>0:
		attackpos = attacks[rng.randi_range(0,attacks.size()-1)]#-get_position()
	
	$HitArea/EnemAttack.rotation_degrees = 0
	$HitArea/EnemAttack.flip_h = false
	$HitArea/EnemAttack.flip_v = false
	$HitArea.show()
	$HitArea/EnemAttack.play("indicator")
	$HitArea.set_position(attackpos)
	
	move_list = []
	movei =0
	var pos_moves
	var next_move
	var initial_pos = position
	for i in range(attack_movement_patterns.tile_move_count):
		if move_list.size() == 0:
			pos_moves  = attack_movement_patterns.enemy_movement_location(position)
		else:
			pos_moves = attack_movement_patterns.enemy_movement_location(move_list[-1])
		for move in pos_moves:
			if move in move_list or move == initial_pos or move in Global.occupied:
				pos_moves.erase(move)
		if pos_moves.size() > 0:
			next_move = pos_moves[rng.randi_range(0,pos_moves.size()-1)]
			move_list.append(next_move)

	if move_list.size() > 0:
		$Move_indicator.show()
		$Move_indicator.set_position(move_list[-1]-position+Vector2(60,60))


func enemy_move():
	if !dead:
		$Enemy_overlap.set_deferred("monitoring",false)
		$Enemy_overlap.set_deferred("monitorable",false)
		if movei < move_list.size():
			var move = move_list[movei]
			movei+=1
			if move in Global.spots and !(move in Global.occupied):
				$EnemySprite.frame = 0
				$EnemySprite.play("Move")
				$CollisionShape2D.set_deferred("disabled",true)
				await get_tree().create_timer(.35).timeout
				if (move.x - position.x < 0):
					direction = "left"
				if (move.x - position.x > 0):
					direction = "right"
				if (move.y - position.y < 0):
					direction = "up"
				if (move.y - position.y > 0):
					direction = "down"
				end = move
				velocity = end - position
			else:
				movei = 100
				enemy_move()
			#previous_move = end
		else:
			Global.occupied.append(position)
			Global.enemy_move_finish.emit()
			$Enemy_overlap.set_deferred("monitoring",true)
			$Enemy_overlap.set_deferred("monitorable",true)
			#previous_move = end
			#hit_area.set_deferred("monitoring", false)


func _on_hit_area_body_entered(body):
	body.killed(get_position())
	$Swordhit.play()


func push(finalPos,value):
	if !dead:
		pushend = get_position() + finalPos
		if pushend in Global.spots:
			$EnemySprite.play("Move")
			$CollisionShape2D.set_deferred("disabled",true)
			await get_tree().create_timer(.35).timeout
			attackpos+=finalPos
			if !(attackpos in Global.spots):
				$HitArea.hide()
			else:
				$HitArea.set_position(attackpos)
			for x in range(0,move_list.size()):
				move_list[x]+=finalPos
			if !move_list[-1] in Global.spots:
				$Move_indicator.hide()
			velocity = pushend-get_position()
			pushdirection=value
			end += finalPos

func killed(area):
	if !dead:
		dead = true
		$CollisionShape2D.set_deferred("disabled",true)
		$EnemySprite.play("die")
		velocity = Vector2.ZERO
		$HitArea.hide()
		$HitArea.monitoring = false
		Global.occupied.erase(position)
		$death.play()

func _on_enemy_sprite_animation_finished() -> void:
	$EnemySprite.play("Face")


func _on_death_finished() -> void:
	Global.enemies_alive-=1
	Global.coins+=1
	queue_free()
