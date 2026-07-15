extends TextureButton


func _ready() -> void:
	Global.gust_check.connect(_on_gust_check)


func _on_gust_check():
	hide()
	if get_position()+Global.playerpos in Global.spots:
		show()

func _on_pressed() -> void:
	Global.tama_move.emit()
	for node in get_children():
		node.monitoring = true
	await get_tree().create_timer(.5).timeout
	for node in get_children():
		node.monitoring = false


func _on_hori_left_body_entered(body: Node2D) -> void:
	body.push(Vector2(120,0),"greater")


func _on_hori_right_body_entered(body: Node2D) -> void:
	body.push(Vector2(-120,0),"lesser")


func _on_hori_up_body_entered(body: Node2D) -> void:
	body.push(Vector2(0,120),"greater")


func _on_hori_down_body_entered(body: Node2D) -> void:
	body.push(Vector2(0,-120),"lesser")
