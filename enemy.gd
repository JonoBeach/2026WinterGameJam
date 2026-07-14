extends CharacterBody2D
@onready var spots = get_parent().get_node("TileMapLayer").get_used_cells()
@onready var pos = get_position()
@onready var attack_movement_patterns = $enemy_attack_and_movement_patterns
var rng = RandomNumberGenerator.new()
var direction
var move
var end = Vector2.ZERO

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	print(Vector2(240, 1100) >= Vector2(240,360))
	for x in range(0,len(spots)):
		spots[x] *=120
	set_position(spots[0])

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
