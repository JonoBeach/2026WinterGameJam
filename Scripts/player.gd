extends CharacterBody2D
@onready var spots = get_parent().get_node("TileMapLayer").get_used_cells()
@onready var pos = get_position()
var rng = RandomNumberGenerator.new()
var direction
var move
var end = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
##gets available tiles and prepares array of them
func _ready() -> void:
	print(Vector2(240, 1100) >= Vector2(240,360))
	for x in range(0,len(spots)):
		spots[x] *=120
	set_position(spots[0])

##move if need to
func _physics_process(_delta):
	if ((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end):
		velocity = Vector2.ZERO
	move_and_slide()
	


##decides move direction and what move
func movedecide():
	##sets direction to move and sets what the final point should be
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
	##sets which action to do
	match rng.randi_range(3,3):
		1:
			move = "attack"
		2:
			move = "defend"
		3:
			move = "move"
	

##does the move
func movedo():
	match move:
		"move":
			velocity = end-get_position() #sets velocity
		"attack":
			#turns on and then off the sword hitbox
			$Sword.monitoring = true
			await get_tree().create_timer(.5).timeout
			$Sword.monitoring = false
		"defend":
			#places shield
			$Shield.play(direction)
			pass


#calls killed() if it touches a body
func _on_sword_body_entered(body: Node2D) -> void:
	body.killed()
