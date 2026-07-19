extends Node

func _on_audio_stream_player_finished() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
