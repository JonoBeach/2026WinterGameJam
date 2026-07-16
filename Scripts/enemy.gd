extends CharacterBody2D
@onready var pos = get_position()
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
@onready var player = $Player
@onready var enemy_sprite = $EnemySprite
@onready var hit_area = $HitArea


var rng = RandomNumberGenerator.new()
var direction
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""
var attacking_tiles

func _ready():
	await get_tree().create_timer(.1).timeout
	set_position(Global.spots[rng.randi_range(0, len(Global.spots)-1)])
	Global.enemy_move.connect(do_attack)

func _physics_process(_delta):
	if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
		velocity = Vector2.ZERO
		direction = ""
		set_position(end)
		Global.enemy_move_finish.emit()
	if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
		velocity = Vector2.ZERO
		pushdirection = ""
		set_position(pushend)
	move_and_slide()

func attack_indicate():
	attacking_tiles = attack_movement_patterns.enemy_attack_pattern()
	pass
	
func do_attack():
	hit_area.set_deferred("monitoring", true)
	attacking_tiles = attack_movement_patterns.enemy_attack_pattern()
	for tile_location in attacking_tiles:
			hit_area.set_position(tile_location)
			
			if hit_area.has_overlapping_bodies():
				for body in hit_area.get_overlapping_bodies():
					print("%s has been attacked" % body)
					
	hit_area.set_deferred("monitoring", false)
	enemy_move()
	
func move_indicate():
	pass

func enemy_move():
	var previous_move = position
	var current_move = position
	var move_list = []
	for i in range(attack_movement_patterns.tile_move_count):
		current_move = end
		end = attack_movement_patterns.enemy_movement_location()
		#print("end %s" % end)
		#print("prev move %s" % previous_move)
			
		while end == previous_move:
			#print("CONDITION MET")
			#print("end %s" % end)
			#print("prev move %s" % previous_move)
			end = attack_movement_patterns.enemy_movement_location()
				
		previous_move = current_move
		# Check if another entity is at destination
		hit_area.set_position(end)
		hit_area.set_deferred("monitoring", true)
		
		if hit_area.has_overlapping_bodies():
			velocity = Vector2.ZERO
			print("HIT")
			hit_area.set_deferred("monitoring", false)
		
		move_list.append(end)
	
	#print(move_list)
	
	for move in move_list:
		hit_area.set_deferred("monitoring", false)
		# Determine direction
		if (move.x - position.x < 0):
			direction = "left"
			enemy_sprite.play("face_left")
		if (move.x - position.x > 0):
			direction = "right"
			enemy_sprite.play("face_right")
			
		if (move.y - position.y < 0):
			direction = "up"
		if (move.y - position.y > 0):
			direction = "down"
			
		velocity = end - position
		#previous_move = end
		await get_tree().create_timer(1).timeout
			
		#previous_move = end
		hit_area.set_deferred("monitoring", false)


func _on_hit_area_body_entered(body):
	return true


func push(finalPos,value):
	pushend = get_position() + finalPos
	if pushend in Global.spots:
		velocity = pushend-get_position()
		pushdirection=value
		end += finalPos
