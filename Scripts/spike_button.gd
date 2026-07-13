extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.gust_check.connect(_on_gust_check)



func _on_gust_check():
	hide()
	if get_position()+Global.playerpos in Global.spots and !(get_position()+Global.playerpos+Vector2(60,60) in Global.spikes):
		show()

func _on_pressed() -> void:
	Global.tama_move.emit()
	var scene = preload("res://Scenes/Spike.tscn")
	var instance = scene.instantiate()
	instance.set_position(get_position()+Global.playerpos+Vector2(60,60))
	get_parent().get_parent().get_parent().add_child(instance)
