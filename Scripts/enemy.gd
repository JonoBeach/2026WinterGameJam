extends CharacterBody2D
@onready var pos = get_position()
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
@onready var player = $Player
@onready var player_animation = $PlayerAnimation

var rng = RandomNumberGenerator.new()
var direction
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""

func _ready():
	set_position(Global.spots[rng.randi_range(0, Global.spots)])

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
		player_animation.play("face_left")
	if (end.x - position.x > 0):
		direction = "right"
		player_animation.play("face_right")
	
	if (end.y - position.y < 0):
		direction = "up"
	if (end.y - position.y > 0):
		direction = "down"
	
	velocity = end - position
	
