class_name enemy_attack_and_movement_patterns
extends Node

@export var enemy : CharacterBody2D
@export var movement_x : int
@export var movement_y : int
@export var randomise_direction : bool
@onready var player = $Player
@onready var enemy_occupying_spots = Global.spots
@onready var tilemap_dimensions = get_parent().get_parent().get_node("TileMapLayer").get_used_rect()
var rng = RandomNumberGenerator.new()

const TILE_SIZE = 120
#var EDGE_MIN_X = Global.spots[0].x
#var EDGE_MAX_X = Global.spots[len(Global.spots)-1].x
#var EDGE_MIN_Y = Global.spots[0].y
#var EDGE_MAX_Y = Global.spots[len(Global.spots)-1].y

@export_enum("Attack Up", "Attack Left", "Attack Down", "Attack Right", "Attack All Directions") var attack_pattern_name : String
@export var attack_size : int

## Returns the location that the enemy will move to, based on its current position.
func enemy_movement_location() -> Vector2:
	enemy_occupying_spots.erase(enemy.position)
	# Need to check if enemy is out of bounds OR there is another entity there
	var new_position = enemy.position
	if !randomise_direction:
		new_position = enemy.position + Vector2(movement_x * TILE_SIZE, movement_y * TILE_SIZE)
	if randomise_direction:
		match rng.randi_range(1, 3): # determine x
			1:
				new_position = enemy.position + Vector2(movement_x * TILE_SIZE, 0)
			2:
				new_position = enemy.position - Vector2(movement_x * TILE_SIZE, 0)
			3:
				pass # no change in x
		
		match rng.randi_range(1, 3): # determine y
			1:
				new_position = enemy.position + Vector2(0, movement_y * TILE_SIZE)
			2:
				new_position = enemy.position - Vector2(0, movement_y * TILE_SIZE)
			3:
				pass # no change in x
	
	#TODO: add prevention of walking over enemies
	if new_position in enemy_occupying_spots:
		pass
		
	# prevention for walking off map
	
	if new_position.x < tilemap_dimensions.position.x * TILE_SIZE:
		new_position.x = tilemap_dimensions.position.x * TILE_SIZE
		
	elif new_position.x > tilemap_dimensions.end.x * TILE_SIZE:
		new_position.x = tilemap_dimensions.end.x * TILE_SIZE
		
	if new_position.y < tilemap_dimensions.position.y * TILE_SIZE:
		new_position.y = tilemap_dimensions.position.y * TILE_SIZE
	
	elif new_position.y > tilemap_dimensions.end.y * TILE_SIZE:
		new_position.y = tilemap_dimensions.end.y * TILE_SIZE
	
	enemy_occupying_spots.append(new_position)
	return new_position
	
	
## Will return the tiles that the enemy will attack, based on attack pattern defined.
func enemy_attack_pattern() -> Array[Vector2]:
	match attack_pattern_name:
		"Attack Up":
			return attack_up()
			
		"Attack Left":
			return attack_left()
			
		"Attack Right":
			return attack_right()
			
		"Attack Down":
			return attack_down()

		"Attack All Directions":
			var attack_tiles = []
			attack_tiles.append(attack_up())
			attack_tiles.append(attack_left())
			attack_tiles.append(attack_right())
			attack_tiles.append(attack_down())
			return attack_tiles
			
		_:
			push_error("Error: %s attack pattern not defined!" % enemy.name)
			return []

func attack_up() -> Array[Vector2]:
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x, enemy.position.y - TILE_SIZE * current_attack)
		if new_move.y >= tilemap_dimensions.position.y * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	
func attack_left() -> Array[Vector2]:
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x - TILE_SIZE * current_attack, enemy.position.y)
		if new_move.x >= tilemap_dimensions.position.x * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	
func attack_right() -> Array[Vector2]:
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x + TILE_SIZE * current_attack, enemy.position.y)
		if new_move.x <= tilemap_dimensions.end.x * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	
func attack_down() -> Array[Vector2]:
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x, enemy.position.y + TILE_SIZE * current_attack)
		if new_move.x <= tilemap_dimensions.end.y * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	

# Called when the node enters the scene tree for the first time.
func _ready():
	print(tilemap_dimensions)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
