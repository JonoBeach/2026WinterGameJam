extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	Global.Moves = ["defend","gust","horizon","gust","spike","teleport"]
	Global.coins = -1
	Global.enemy_count = 4
	Global.enemies_alive = 0
	Global.occupied = []
	Global.spikes = []
	Global.shields = [] 
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_theme_finished() -> void:
	$Theme.play()
