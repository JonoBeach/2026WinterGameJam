extends CharacterBody2D
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
@onready var player = get_parent().get_node("Player")
@onready var enemy_sprite = $EnemySprite
@onready var hit_area = $HitArea
@onready var spots = get_parent().get_node("enemypositions").get_used_cells()
var attacked = false
var finished = false
var attackpos
var attacks
var movei = 0
var move_list = []
var rng = RandomNumberGenerator.new()
var direction
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""
var attacking_tiles
@onready var attack_indicators = [$HitArea/EnemAttack, $HitArea/EnemAttackInd1, $HitArea/EnemAttackInd2, $HitArea/EnemAttackInd3]
var dead = false


func _ready():
	Global.enemy_move.connect(do_attack)
	Global.enemy_calculate_move.connect(calculate_enemy_move)
	Global.enemy_walk_start.connect(enemy_move)
	Global.occupied.append(position)

func _physics_process(_delta):
	if !dead:
		if !player == null:
			match position.y:
				240.0:
					z_index = -1
				360.0:
					z_index = 0
				480.0:
					z_index = 1
				600.0:
					z_index = 2
				720.0:
					z_index = 3
		if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
			velocity = Vector2.ZERO
			direction = ""
			set_position(end)
			$CollisionShape2D.set_deferred("disabled",false)
			$HitArea.show()
			enemy_move()
		if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
			velocity = Vector2.ZERO
			pushdirection = ""
			set_position(pushend)
			$HitArea.show()
			var i = len(move_list)-1
			while move_list[i] not in Global.spots:
				i-=1
			if i > -1:
				$Move_indicator.set_position(move_list[i]-position+Vector2(60,60))
				$Move_indicator.show()
			$CollisionShape2D.set_deferred("disabled",false)
		if $Enemy_overlap.monitoring:
			if $Enemy_overlap.get_overlapping_areas().size()>0:
				$Enemy_overlap.get_overlapping_areas()[0].get_parent().killed(Vector2(0,0))
				#$Enemy_overlap/CollisionShape2D.disabled = true
		move_and_slide()

	
func do_attack():
	if !dead:
		$Move_indicator.hide()
		$HitArea.hide()
		$EnemySprite.play("Attack")
		await get_tree().create_timer(1.4).timeout
				#$Swordslash.play()
		hit_area.set_deferred("monitoring", true)
		$Attack.play("default")
		$Swordslash.play()
				
		await get_tree().create_timer(1).timeout
		$HitArea.hide()
		hit_area.set_deferred("monitoring", false)

		
		Global.occupied.erase(position)
		Global.enemy_attack_finish.emit()
		attacked = true
	
func move_indicate():
	pass

func calculate_enemy_move():
	attacked = false
	finished = false
	attacking_tiles = [Vector2(0,120),Vector2(0,-120),Vector2(120,0),Vector2(-120,0)]
	#attackpos = attacks[rng.randi_range(0,attacks.size()-1)]#-get_position()
	for attack_indi in attack_indicators:
		attack_indi.hide()
	for attack_num in range(len(attacking_tiles)):
		attackpos = attacking_tiles[attack_num]
		if attackpos+position in Global.spots:
			$HitArea.show()
			attack_indicators[attack_num].show()
			attack_indicators[attack_num].set_position(attacking_tiles[attack_num] + Vector2(180, 60))
	
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
			$HitArea.hide()
			var move = move_list[movei]
			movei+=1
			if move in Global.spots and !(move in Global.occupied):
				$EnemySprite.frame = 0
				$EnemySprite.play("Move")
				$CollisionShape2D.set_deferred("disabled",true)
				await get_tree().create_timer(1).timeout
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
			finished = true
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
			for attack_indi in attack_indicators:
				attack_indi.hide()
			for attack_num in range(len(attacking_tiles)):
				attackpos = attacking_tiles[attack_num]+finalPos
				if attackpos+position in Global.spots:
					$HitArea.show()
					attack_indicators[attack_num].show()
					attack_indicators[attack_num].set_position(attacking_tiles[attack_num] + Vector2(180, 60))
			$EnemySprite.play("Move")
			$CollisionShape2D.set_deferred("disabled",true)
			$Move_indicator.hide()
			$HitArea.hide()
			await get_tree().create_timer(1).timeout
			
			#attackpos+=finalPos
			
			for x in range(0,move_list.size()):
				move_list[x]+=finalPos
			#if !move_list[-1] in Global.spots:
				#$Move_indicator.hide()
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
	if !finished:
		Global.enemy_move_finish.emit()
	if !attacked:
		Global.enemy_attack_finish.emit()
	Global.enemies_alive-=1
	Global.coins+=1
	queue_free()


func _on_attack_animation_finished() -> void:
	$Attack.play("empty")
