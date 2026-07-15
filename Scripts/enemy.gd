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

func _physics_process(_delta):
	if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
		velocity = Vector2.ZERO
		direction = ""
	if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
		velocity = Vector2.ZERO
		pushdirection = ""
	move_and_slide()

func attack_indicate():
	attacking_tiles = attack_movement_patterns.enemy_attack_pattern()
	pass
	
func do_attack():
	attacking_tiles = attack_movement_patterns.enemy_attack_pattern()
	for tiles in attacking_tiles:
		for tile_location in tiles:
			hit_area.set_position(tile_location)
			if hit_area.body_entered:
				for body in hit_area.get_overlapping_bodies():
					print("%s has been attacked" % body)
	
func move_indicate():
	pass

func enemy_move():
	end = attack_movement_patterns.enemy_movement_location()
	
	# Determine direction
	if (end.x - position.x < 0):
		direction = "left"
		enemy_sprite.play("face_left")
	if (end.x - position.x > 0):
		direction = "right"
		enemy_sprite.play("face_right")
	
	if (end.y - position.y < 0):
		direction = "up"
	if (end.y - position.y > 0):
		direction = "down"
	
	velocity = end - position
