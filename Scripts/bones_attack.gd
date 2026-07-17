extends CharacterBody2D

var direction

func _ready() -> void:
	match direction:
		"up":
			velocity.y = -120
		"down":
			velocity.y = 120
		"left":
			velocity.x = -120
		"right":
			velocity.x = 120
	await get_tree().create_timer(3).timeout
	kill()

func _physics_process(delta: float) -> void:
	if position.x < 180 or position.x > 1620 or position.y<180 or position.y>780:
		kill()
	move_and_slide()

func kill():
	var enem = get_parent()
	if enem != null:
		enem.done()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.killed(get_position())
	kill()
