extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.shields.append(get_position())
