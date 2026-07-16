class_name enemy_attack_and_movement_patterns
extends Node

@export var enemy : CharacterBody2D
@export var tile_move_count: int = 1
@onready var player = $Player
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
func enemy_movement_location():
	#print("POS" + tilemap_dimensions.position)
	#print("END" + tilemap_dimensions.end)
	#print(Global.spots)
	
	# Need to check if enemy is out of bounds OR there is another entity there
	var new_position = enemy.position
	match rng.randi_range(1, 4):
		1:
			new_position = enemy.position + Vector2(TILE_SIZE, 0)
		2:
			new_position = enemy.position - Vector2(TILE_SIZE, 0)
		3:
			new_position = enemy.position + Vector2(0, TILE_SIZE)
		4:
			new_position = enemy.position - Vector2(0, TILE_SIZE)
		
	#TODO: add prevention of walking over enemies
	
		
	# prevention for walking off map
	
	if new_position.x < tilemap_dimensions.position.x * TILE_SIZE:
		new_position.x = tilemap_dimensions.position.x * TILE_SIZE
		
	elif new_position.x > (tilemap_dimensions.end.x * TILE_SIZE) - TILE_SIZE:
		new_position.x = (tilemap_dimensions.end.x * TILE_SIZE) - TILE_SIZE
		
	if new_position.y < tilemap_dimensions.position.y * TILE_SIZE:
		new_position.y = tilemap_dimensions.position.y * TILE_SIZE
	
	elif new_position.y > (tilemap_dimensions.end.y * TILE_SIZE) - TILE_SIZE:
		new_position.y = (tilemap_dimensions.end.y * TILE_SIZE) - TILE_SIZE
		
	return new_position
	
	
## Will return the tiles that the enemy will attack, based on attack pattern defined.
func enemy_attack_pattern():
	var attack_tiles = []
	match attack_pattern_name:
		"Attack Up":
			attack_tiles += attack_up()
			return attack_tiles
			
		"Attack Left":
			attack_tiles += attack_left()
			return attack_tiles
			
		"Attack Right":
			attack_tiles += attack_right()
			return attack_tiles
			
		"Attack Down":
			attack_tiles += attack_down()
			return attack_tiles

		"Attack All Directions":
			attack_tiles += attack_up()
			attack_tiles += attack_left()
			attack_tiles += attack_right()
			attack_tiles += attack_down()
			return attack_tiles
			
		_:
			push_error("Error: %s attack pattern not defined!" % enemy.name)
			return []

func attack_up():
	print(tilemap_dimensions.position.y)
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x, enemy.position.y - TILE_SIZE * current_attack)
		if new_move.y >= tilemap_dimensions.position.y * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	
func attack_left():
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x - TILE_SIZE * current_attack, enemy.position.y)
		if new_move.x >= tilemap_dimensions.position.x * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	
func attack_right():
	var new_move
	var attack_tiles = []
	for current_attack in range(1, attack_size+1):
		new_move = Vector2(enemy.position.x + TILE_SIZE * current_attack, enemy.position.y)
		if new_move.x <= tilemap_dimensions.end.x * TILE_SIZE:
			attack_tiles.append(new_move)
	return attack_tiles
	
func attack_down():
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
