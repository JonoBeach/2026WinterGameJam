extends TextureButton


func _ready() -> void:
	Global.gust_check.connect(_on_gust_check)



func _on_gust_check():
	hide()
	if get_position()+Global.playerpos in Global.spots:
		show()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.killed(get_position()+Global.playerpos)


func _on_pressed() -> void:
	Global.tama_move.emit()
	var pos = [Vector2(0,0),Vector2(120,0),Vector2(-120,0),Vector2(0,120),Vector2(0,-120)]
	var scene = preload("res://Scenes/Fireball.tscn")
	for x in pos:
		if x+get_position()+Global.playerpos in Global.spots:
			var instance = scene.instantiate()
			instance.set_position(x+get_position()+Global.playerpos+Vector2(60,60))
			get_parent().get_parent().get_parent().add_child(instance)
	await get_tree().create_timer(1).timeout
	$fireball.play()
	$Area2D.monitoring = true
	$Area2D.monitorable = true
	await get_tree().create_timer(1).timeout
	$Area2D.monitoring = false
	$Area2D.monitorable = false
