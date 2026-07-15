extends TextureButton

func _ready() -> void:
	Global.gust_check.connect(_on_gust_check)


func _on_pressed() -> void:
	Global.tama_move.emit()
	var scene = preload("res://Scenes/Gust.tscn")
	var instance = scene.instantiate()
	instance.set_position(get_position()+Global.playerpos+Vector2(60,60))
	get_parent().get_parent().get_parent().add_child(instance)
	await get_tree().create_timer(.3).timeout
	for node in get_children():
		node.get_node("CollisionShape2D").set_deferred("disabled",false)
	await get_tree().create_timer(.5).timeout
	for node in get_children():
		node.get_node("CollisionShape2D").set_deferred("disabled",true)


func _on_gust_down_body_entered(body: Node2D) -> void:
	body.push(Vector2(0,120),"greater")


func _on_gust_up_body_entered(body: Node2D) -> void:
	body.push(Vector2(0,-120),"lesser")


func _on_gust_right_body_entered(body: Node2D) -> void:
	body.push(Vector2(120,0),"greater")


func _on_gust_left_body_entered(body: Node2D) -> void:
	body.push(Vector2(-120,0),"lesser")

func _on_gust_check():
	hide()
	if get_position()+Global.playerpos in Global.spots:
		show()
