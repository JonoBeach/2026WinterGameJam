extends Area2D

func _ready() -> void:
	Global.spikes.append(get_position())
	await get_tree().create_timer(2).timeout
	Global.spell_finished.emit()
	set_deferred("monitoring",true)


func _on_body_entered(body: Node2D) -> void:
	body.killed(get_position())
	Global.spikes.erase(get_position())
	queue_free()
