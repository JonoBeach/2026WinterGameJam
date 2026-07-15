extends Button


func _on__pressed() -> void:
	if Global.coins >= 3 and Global.Moves.size() >3:
		Global.coins -=3
		var x = str($AnimatedSprite2D.get_animation())
		Global.Moves.erase(x)
		get_parent().get_parent().done()


func _on_mouse_entered() -> void:
	get_parent().get_parent().get_node("Description").show()
	get_parent().get_parent().DescSet($AnimatedSprite2D.animation)
