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
	queue_free()

func _physics_process(delta: float) -> void:
	if position.x < 180 or position.x > 1620 or position.y<180 or position.y>780:
		queue_free()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.killed(get_position())
	queue_free()
