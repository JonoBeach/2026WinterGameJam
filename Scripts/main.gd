extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.movedecide()
	Global.shields = []
	Global.spikes = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

##called when end turn button pressed
func endturn():
	$Player.movedo()
	await get_tree().create_timer(2).timeout
	$Mainhud.reset()
	$Player.movedecide()
	$Enemy.do_attack()
	$Enemy.enemy_move()
