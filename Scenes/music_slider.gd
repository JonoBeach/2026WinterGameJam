extends HSlider


func _on_value_changed(value):
	var bgm_index = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_volume_db(bgm_index, linear_to_db(value))
