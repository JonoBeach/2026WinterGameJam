extends CharacterBody2D


var direction


func _physics_process(delta: float) -> void:

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.killed(get_position()+Global.playerpos)
	velocity = Ve
