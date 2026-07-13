extends CharacterBody2D
@onready var spots = get_parent().get_node("TileMapLayer").get_used_cells()
@onready var pos = get_position()
var rng = RandomNumberGenerator.new()
var direction
var move
var end = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Vector2(240, 1100) >= Vector2(240,360))
	for x in range(0,len(spots)):
		spots[x] *=120
	set_position(spots[0])

func _physics_process(_delta):
	if ((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end):
		velocity = Vector2.ZERO
	move_and_slide()
	


func movedecide():
	match rng.randi_range(1,4):
		1:
			direction = "up"
			end = get_position() + Vector2(0,-120)
			if !end in spots:
				direction = "down"
				end += Vector2(0,240)
		2:
			direction = "right"
			end = get_position() + Vector2(120,0)
			if !end in spots:
				direction = "left"
				end += Vector2(-240,0)
		3:
			direction = "down"
			end = get_position() + Vector2(0,120)
			if !end in spots:
				direction = "up"
				end += Vector2(0,-240)
		4:
			direction = "left"
			end = get_position() + Vector2(-120,0)
			if !end in spots:
				direction = "right"
				end += Vector2(240,0)
	$PlayerAnim.play("Face"+direction)
	match rng.randi_range(3,3):
		1:
			move = "attack"
		2:
			move = "defend"
		3:
			move = "move"
	

func movedo():
	match move:
		"move":
			velocity = (end-get_position())
			
