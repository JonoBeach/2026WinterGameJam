extends AnimatedSprite2D

func _on_animation_finished() -> void:
	await get_tree().create_timer(.8).timeout
	Global.spell_finished.emit()
	queue_free()
