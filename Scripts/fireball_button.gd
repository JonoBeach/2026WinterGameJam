extends TextureButton


func _ready() -> void:
	Global.gust_check.connect(_on_gust_check)



func _on_gust_check():
	hide()
	if get_position()+Global.playerpos in Global.spots:
		show()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.killed()


func _on_pressed() -> void:
	Global.tama_move.emit()
	$Area2D.monitoring = true
	$Area2D.monitorable = true
	await get_tree().create_timer(.5).timeout
	$Area2D.monitoring = false
	$Area2D.monitorable = false
