class_name enemy_attack_and_movement_patterns
extends Node

@export var enemy : CharacterBody2D
@export var movement_x : int
@export var movement_y : int
@export var randomise_direction : bool
@onready var player = $Player
@onready var enemy_occupying_spots = Global.spots

const TILE_SIZE = 120
var EDGE_MIN_X = Global.spots[0].x
var EDGE_MAX_X = Global.spots[len(Global.spots)-1].x
var EDGE_MIN_Y = Global.spots[0].y
var EDGE_MAX_Y = Global.spots[len(Global.spots)-1].y

@export_enum("Attack Forward") var attack_pattern_name : String

## Returns the location that the enemy will move to, based on its current position.
func enemy_movement_location() -> Vector2:
	enemy_occupying_spots.remove(enemy.position)
	# Need to check if enemy is out of bounds OR there is another entity there
	var new_position = enemy.position + Vector2(movement_x * TILE_SIZE, movement_y * TILE_SIZE)
	
	#TODO: add prevention of walking over enemies
	if new_position in enemy_occupying_spots:
		pass
		
	# prevention for walking off map
	if new_position.x < EDGE_MIN_X:
		new_position.x = EDGE_MIN_X
		
	elif new_position.x > EDGE_MAX_X:
		new_position.x = EDGE_MAX_X
		
	if new_position.y < EDGE_MIN_Y:
		new_position.y = EDGE_MIN_Y
	
	elif new_position.y > EDGE_MAX_Y:
		new_position.y = EDGE_MAX_Y
	
	enemy_occupying_spots.add(new_position)
	return new_position
	
	
## Will return the tiles that the enemy will attack, based on attack pattern defined.
func enemy_attack_pattern() -> Array[Vector2]:
	match attack_pattern_name:
		"Attack Forward":
			print("Placeholder move done")
			return []
		_:
			push_error("Error: %s attack pattern not defined!" % enemy.name)
			return []



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
