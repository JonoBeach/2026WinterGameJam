extends CharacterBody2D
@onready var pos = get_position()
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns2
@onready var player = $Player
@onready var enemy_sprite = $EnemySprite

var rng = RandomNumberGenerator.new()
var direction
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""

func _ready():
	await get_tree().create_timer(.1).timeout
	set_position(Global.spots[rng.randi_range(0, len(Global.spots))])

func _physics_process(_delta):
	if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
		velocity = Vector2.ZERO
		direction = ""
	if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
		velocity = Vector2.ZERO
		pushdirection = ""
	move_and_slide()

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
