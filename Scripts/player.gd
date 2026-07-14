extends CharacterBody2D
@onready var spots = get_parent().get_node("TileMapLayer").get_used_cells()
var rng = RandomNumberGenerator.new()
var direction
var move
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""

# Called when the node enters the scene tree for the first time.
##gets available tiles and prepares array of them
func _ready() -> void:
	for x in range(0,len(spots)):
		spots[x] *=120
	set_position(spots[10])
	Global.spots = spots
	print(spots)
	Global.tama_move.connect(_on_move_finish)


##move if need to
func _physics_process(_delta):
	if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
		velocity = Vector2.ZERO
		direction = ""
	if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
		velocity = Vector2.ZERO
		pushdirection = ""
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
	match rng.randi_range(1,3):
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
			if end in spots:
				velocity = end-get_position() #sets velocity
		"attack":
			#turns on and then off the sword hitbox
			$Sword.monitoring = true
			$Sword.set_position(end-get_position())
			await get_tree().create_timer(.5).timeout
			$Sword.monitoring = false
		"defend":
			#places shield
			#$Shield.play(direction)
			pass

func push(finalPos,value):
	pushend = get_position() + finalPos
	if pushend in spots:
		velocity = pushend-get_position()
		pushdirection=value
		end += finalPos

#calls killed() if it touches a body
func _on_sword_body_entered(body: Node2D) -> void:
	body.killed()

func killed():
	queue_free()

func defend():
	$Defend.show()
	for node in $Defend.get_children():
		node.hide()
		if (node.get_position()+get_position()) in spots:
			node.show()
		

func _on_right_pressed() -> void:
	Global.tama_move.emit()
	pass # Replace with function body.


func _on_left_pressed() -> void:
	Global.tama_move.emit()
	pass # Replace with function body.


func _on_up_pressed() -> void:
	Global.tama_move.emit()
	pass # Replace with function body.


func _on_down_pressed() -> void:
	Global.tama_move.emit()
	pass # Replace with function body.

func Gust():
	$Gust.show()
	Global.playerpos = get_position()
	Global.gust_check.emit()

func _on_move_finish():
	$Defend.hide()
	$Gust.hide()
	$Spike.hide()
	$Fireball.hide()
	$Tamadachi.play("Action")
	await get_tree().create_timer(1).timeout
	$Tamadachi.play("Idle")

func Spike():
	$Spike.show()
	Global.playerpos = get_position()
	Global.gust_check.emit()

func Fireball():
	$Fireball.show()
	Global.playerpos = get_position()
	Global.gust_check.emit()

func Bulwark():
	pass

func Horizon():
	$Horizon.show()
	Global.playerpos = get_position()
	Global.gust_check.emit()
