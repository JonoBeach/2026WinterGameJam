class_name enemy_attack_and_movement_patterns
extends Node

@export var enemy : CharacterBody2D
@export var movement_x : int
@export var movement_y : int
const TILE_SIZE = 120

@export_enum("Placeholder") var attack_pattern_name : String

## Returns the location that the enemy will move to, based on its current position.
func enemy_movement_location() -> Vector2:
	# Need to check if enemy is out of bounds OR there is another entity there
	return enemy.position + Vector2(movement_x * TILE_SIZE, movement_y * TILE_SIZE)
	
	
## Will return the tiles that the enemy will attack, based on attack pattern defined.
func enemy_attack_pattern() -> Array[Vector2]:
	match attack_pattern_name:
		"Placeholder":
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
