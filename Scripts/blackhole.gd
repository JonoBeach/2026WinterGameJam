extends AnimatedSprite2D

func _on_animation_finished() -> void:
	Global.spell_finished.emit()
	queue_free()
