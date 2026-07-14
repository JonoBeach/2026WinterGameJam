extends CharacterBody2D
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
var rng = RandomNumberGenerator.new()
var direction
var move
var end = Vector2.ZERO


func _ready():
	set_position(Global.spots[10])

func _physics_process(delta):
	move_and_slide()
