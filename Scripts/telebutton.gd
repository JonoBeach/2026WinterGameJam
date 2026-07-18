extends TextureButton


func _ready() -> void:
	Global.gust_check.connect(_on_gust_check)


func _on_gust_check():
	hide()
	if get_position()+Global.playerpos in Global.spots:
		show()


func _on_pressed() -> void:
	Global.tama_move.emit()
	await get_tree().create_timer(.8).timeout
	$AudioStreamPlayer.play()
	get_parent().get_parent().tp(get_position()+Global.playerpos)
