extends CharacterBody2D
@onready var spots = get_parent().get_node("TileMapLayer").get_used_cells()
var rng = RandomNumberGenerator.new()
var direction
var move = ""
var end = Vector2.ZERO
var pushend = Vector2.ZERO
var pushdirection = ""

# Called when the node enters the scene tree for the first time.
##gets available tiles and prepares array of them
func _ready() -> void:
	for x in range(0,len(spots)):
		spots[x] *=120
	set_position(spots[6])
	Global.occupied.append(get_position())
	Global.spots = spots
	Global.tama_move.connect(_on_move_finish)


##move if need to
func _physics_process(_delta):
	if pushdirection == "" and (((direction == "left" or direction == "up") and get_position() <= end) or ((direction == "right" or direction == "down") and get_position() >= end)):
		velocity = Vector2.ZERO
		direction = ""
		set_position(end)
		Global.player_move_finish.emit()
	if (pushdirection == "lesser" and get_position()<=pushend) or (pushdirection == "greater" and get_position()>=pushend):
		velocity = Vector2.ZERO
		pushdirection = ""
		set_position(pushend)
	if move == "":
		$MoveChoice.play("empty")
		$Direction.play("empty")
	move_and_slide()
	


##decides move direction and what move
func movedecide():
	##sets direction to move and sets what the final point should be
	Global.shields = []
	for node in get_children():
		if "Shield" in node.name or "Area2D@8" in node.name:
			node.queue_free()
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
	$Direction.play(direction)
	##sets which action to do
	match rng.randi_range(1,3):
		1:
			move = "attack"
		2:
			move = "defend"
		3:
			move = "move"
	$MoveChoice.play(move)
	

##does the move
func movedo():
	$Direction.play("empty")
	$MoveChoice.play("empty")
	match move:
		"move":
			if end in spots and !(end in Global.occupied):
				Global.occupied.erase(get_position())
				Global.occupied.append(end)
				velocity = end-get_position() #sets velocity
				$PlayerAnim.play("move")
				
		"attack":
			#turns on and then off the sword hitbox
			$PlayerAnim.play("use")
			match direction:
				"up":
					$Sword/AnimatedSprite2D.rotation_degrees = -90
					$Sword/AnimatedSprite2D.flip_h = false
				"down":
					$Sword/AnimatedSprite2D.rotation_degrees = 90
					$Sword/AnimatedSprite2D.flip_h = false
				"left":
					$Sword/AnimatedSprite2D.rotation_degrees = 0
					$Sword/AnimatedSprite2D.flip_h = true
					$PlayerAnim.flip_h = true
				"right":
					$Sword/AnimatedSprite2D.rotation_degrees = 0
					$Sword/AnimatedSprite2D.flip_h = false
			await get_tree().create_timer(1.1).timeout
			$Sword/AnimatedSprite2D.play("attack")
			$Sword.monitoring = true
			$SwordSlash.play()
			$Sword.set_position(end-get_position())
			await get_tree().create_timer(.6).timeout
			$Sword.monitoring = false
			$PlayerAnim.flip_h = false
			Global.player_move_finish.emit()
		"defend":
			if end in spots and !(end-get_position() in Global.shields):
				$PlayerAnim.play("use")
				if direction == "left":
					$PlayerAnim.flip_h = true
			await get_tree().create_timer(1.1).timeout
			if end in spots and !(end-get_position() in Global.shields):
				var scene = preload("res://Scenes/Shield.tscn")
				var instance = scene.instantiate()
				instance.set_position(end-get_position())
				instance.direction = direction
				instance.origin = "knight"
				add_child(instance)
			await get_tree().create_timer(.6).timeout
			$PlayerAnim.flip_h = false
			Global.player_move_finish.emit()
		_:
			await get_tree().create_timer(.1).timeout
			Global.player_move_finish.emit()

func push(finalPos,value):
	pushend = get_position() + finalPos
	if pushend in spots:
		Global.occupied.erase(get_position())
		Global.occupied.append(pushend)
		$PlayerAnim.play("move")
		velocity = pushend-get_position()
		pushdirection=value
		end += finalPos


#calls killed() if it touches a body
func _on_sword_body_entered(body: Node2D) -> void:
	body.killed(get_position())
	$swordhit.play()

func killed(area):
	if area == Vector2(0,0):
		$death.play()
	else:
		print(area,position, Global.shields)
		if (area.x < position.x and Vector2(-120,0) in Global.shields) or (area.x>position.x and Vector2(120,0) in Global.shields) or(area.y < position.y and Vector2(0,-120) in Global.shields) or (area.y>position.y and Vector2(0,120) in Global.shields):
			$shieldblock.play()
		else:
			$death.play()

func defend():
	$Defend.show()
	for node in $Defend.get_children():
		node.hide()
		if (node.get_position()+get_position()) in spots and !(node.get_position() in Global.shields):
			node.show()

func _on_right_pressed() -> void:
	var scene = preload("res://Scenes/Shield.tscn")
	var instance = scene.instantiate()
	instance.set_position(Vector2(120,0))
	instance.direction = "right"
	instance.origin = "tama"
	add_child(instance)
	Global.tama_move.emit()



func _on_left_pressed() -> void:
	var scene = preload("res://Scenes/Shield.tscn")
	var instance = scene.instantiate()
	instance.set_position(Vector2(-120,0))
	instance.direction = "left"
	instance.origin = "tama"
	add_child(instance)
	Global.tama_move.emit()



func _on_up_pressed() -> void:
	var scene = preload("res://Scenes/Shield.tscn")
	var instance = scene.instantiate()
	instance.set_position(Vector2(0,-120))
	instance.direction = "up"
	instance.origin = "tama"
	add_child(instance)
	Global.tama_move.emit()



func _on_down_pressed() -> void:
	var scene = preload("res://Scenes/Shield.tscn")
	var instance = scene.instantiate()
	instance.set_position(Vector2(0,120))
	instance.direction = "down"
	instance.origin = "tama"
	add_child(instance)
	Global.tama_move.emit()

func Gust():
	$Gust.show()
	Global.playerpos = get_position()
	Global.gust_check.emit()

func _on_move_finish():
	$Defend.hide()
	$Gust.hide()
	$Spike.hide()
	$Fireball.hide()
	$Horizon.hide()
	$Tamadachi.play("Action")
	$Spell.play()
	await get_tree().create_timer(0.85).timeout
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
	var places = [Vector2(120,0),Vector2(-120,0),Vector2(0,-120),Vector2(0,120)]
	var dir = ["right","left","up","down"]
	Global.tama_move.emit()
	for x in range(0,4):
		if !(places[x] in Global.shields) and places[x]+get_position() in spots:
			var scene = preload("res://Scenes/Shield.tscn")
			var instance = scene.instantiate()
			instance.set_position(places[x])
			instance.direction = dir[x]
			instance.origin = "tama"
			add_child(instance)
	

func Horizon():
	$Horizon.show()
	Global.playerpos = get_position()
	Global.gust_check.emit()


func _on_player_anim_animation_finished() -> void:
	$PlayerAnim.play("Face")


func _on_death_finished() -> void:
	get_parent().dead = true
	hide()
