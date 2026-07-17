extends Area2D

func _ready() -> void:
	Global.spikes.append(get_position())


func _on_body_entered(body: Node2D) -> void:
	body.killed(get_position())
	Global.spikes.erase(get_position())
	queue_free()
