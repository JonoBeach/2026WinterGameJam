extends Node
var diai = 0
var dialogue = [[],[]]
var rng = RandomNumberGenerator.new()
@onready var spots = $enemypositions.get_used_cells()
var enemies_finished = 0
var enemcount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemcount = Global.enemy_count
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
	Global.enemy_dead.connect(_on_death)
	for x in range(0,Global.enemy_count):
		match rng.randi_range(3,3):
			1:
				var scene = preload("res://Scenes/enemy.tscn")
				var instance = scene.instantiate()
				var i =rng.randi_range(0, len(spots)-1)
				instance.set_position(spots[i]*120)
				spots.remove_at(i)
				add_child(instance)
			2:
				pass
			3:
				var scene = preload("res://Scenes/berserker.tscn")
				var instance = scene.instantiate()
				var i =rng.randi_range(0, len(spots)-1)
				instance.set_position(spots[i]*120)
				spots.remove_at(i)
				add_child(instance)
				
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
	
	enemies_finished = 0
	Global.enemy_move.emit()

func _on_enemy_finished():
	enemies_finished+=1
	if enemies_finished == enemcount:
		$Mainhud.reset()
		$Player.movedecide()
		Global.enemy_calculate_move.emit()

func _on_death():
	enemcount-=1
