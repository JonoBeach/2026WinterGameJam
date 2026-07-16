extends Node
var diai = 0
var dialogue = [[],[]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.coins == -1:
		$Dialogue.show()
		$Mainhud.hide()
	else:
		$Dialogue.hide()
		$Mainhud.show()
	$Player.movedecide()
	Global.shields = []
	Global.spikes = []
	var f = FileAccess.open("res://Dialogue/Tutorial.txt",FileAccess.READ).get_as_text()
	f = f.replace("\n","|").split("|")
	for x in range(0,len(f),2):
		dialogue[0].append(f[x])
		if x < len(f)-1:
			dialogue[1].append(f[x+1])
	$Dialogue/Title.text = dialogue[0][diai]
	$Dialogue/Body.text = dialogue[1][diai]
	Global.player_move_finish.connect(_on_player_finished)
	Global.enemy_move_finish.connect(_on_enemy_finished)
	for x in range(0,Global.enemy_count):
		pass #spawn x amount of enemies
	Global.enemy_calculate_move.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

##called when end turn button pressed
func endturn():
	$Player.movedo()
	
	


func _on_next_pressed() -> void:
	diai +=1
	if diai < len(dialogue[0]):
		$Dialogue/Title.text = dialogue[0][diai]
		$Dialogue/Body.text = dialogue[1][diai]
	else:
		$Dialogue.hide()
		$Mainhud.show()

func _on_player_finished():
	$Player.movedecide()
	Global.enemy_move.emit()

func _on_enemy_finished():
	print(Global.occupied)
	$Mainhud.reset()
	Global.enemy_calculate_move.emit()
