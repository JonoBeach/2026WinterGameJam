extends CharacterBody2D
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
@onready var player = get_parent().get_node("Player")
@onready var enemy_sprite = $EnemySprite
@onready var spots = get_parent().get_node("enemypositions").get_used_cells()

var attackdirection
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
			if position.y < player.position.y:
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
			hitIndic()
			$CollisionShape2D.set_deferred("disabled",false)
		if $Enemy_overlap.monitoring:
			if $Enemy_overlap.get_overlapping_areas().size()>0:
				$Enemy_overlap.get_overlapping_areas()[0].get_parent().killed(Vector2(0,0))
				$Enemy_overlap/CollisionShape2D.disabled = true
		move_and_slide()

func attack_indicate():
	attacking_tiles = attack_movement_patterns.enemy_attack_pattern()



func hitIndic():
	var indicate
	if (attackpos in Global.spots):
		match attackpos-get_position():
			Vector2(0,120):
				indicate = $DownIndicate
				attackdirection = "down"
			Vector2(0,-120):
				indicate = $UpIndicate
				attackdirection = "up"
			Vector2(-120,0):
				indicate = $LeftIndicate
				attackdirection = "left"
			Vector2(120,0):
				indicate = $RightIndicate
				attackdirection = "right"
			_:
				indicate = $RightIndicate
				attackdirection = "right"
		indicate.show()
		indicate.set_position(attackpos)
		for node in indicate.get_children():
			node.hide()
			if node.position +indicate.position-Vector2(60,60) in Global.spots:
				node.show()

func do_attack():
	$Move_indicator.hide()
	$DownIndicate.hide()
	$UpIndicate.hide()
	$LeftIndicate.hide()
	$RightIndicate.hide()
	if (attackpos in Global.spots):
		$EnemySprite.play("Attack")
		await get_tree().create_timer(.3).timeout
		$spell.play()
		await get_tree().create_timer(.7).timeout
		var scene = preload("res://Scenes/BonesAttack.tscn")
		var instance = scene.instantiate()
		instance.set_position(attackpos)
		instance.direction = attackdirection
		add_child(instance)
		#await get_tree().create_timer(4).timeout

	


func done():
	Global.occupied.erase(position)
	Global.enemy_attack_finish.emit()

func move_indicate():
	pass

func calculate_enemy_move():
	var attacks = attack_movement_patterns.enemy_movement_location(position)
	if attacks.size()>0:
		attackpos = attacks[rng.randi_range(0,attacks.size()-1)]#-get_position()
	
	hitIndic()
	
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
	$Enemy_overlap.set_deferred("monitoring",false)
	$Enemy_overlap.set_deferred("monitorable",false)
	if movei < move_list.size():
		var move = move_list[movei]
		movei+=1
		if move in Global.spots and !(move in Global.occupied):
			$CollisionShape2D.set_deferred("disabled",true)
			$EnemySprite.frame = 0
			$EnemySprite.play("Move")
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



func push(finalPos,value):
	pushend = get_position() + finalPos
	if pushend in Global.spots:
		$CollisionShape2D.set_deferred("disabled",true)
		$DownIndicate.hide()
		$UpIndicate.hide()
		$LeftIndicate.hide()
		$RightIndicate.hide()
		$EnemySprite.play("Move")
		await get_tree().create_timer(.35).timeout
		attackpos+=finalPos
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
		$EnemySprite.set_position(Vector2(60,0))
		velocity = Vector2.ZERO
		Global.occupied.erase(position)
		$death.play()


func _on_enemy_sprite_animation_finished() -> void:
	$EnemySprite.play("Face")



func _on_death_finished() -> void:
	Global.enemies_alive-=1
	Global.coins+=1
	queue_free()
