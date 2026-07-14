extends CanvasLayer
var rng = RandomNumberGenerator.new()
#variables for tamadachi movesets
var moves = Global.Moves.duplicate()
var avaiMoves = []
var discards = []
var actioning = false
var energy = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assignMoves()
	Global.tama_move.connect(_on_move_finish)

func _process(delta: float) -> void:
	$Energy.text = str(energy)+"/3"

func _on_end_turn_pressed() -> void:
	get_parent().endturn()
	$EndTurn.hide()

func reset():
	$EndTurn.show()
	energy+=3
	assignMoves()


##generates three moves for the player out of their possible options
func assignMoves():

	discards+=avaiMoves
	avaiMoves = []
	if moves.size() < 3:
		moves+=discards
		discards = []
	
	for i in range(0,3):
		var index = rng.randi_range(0,moves.size()-1)
		get_node(str(i)).show()
		get_node(str(i)+"/AnimatedSprite2D").play(moves[index])
		avaiMoves.append(moves[index])
		moves.remove_at(index)

func _on_button_pressed() -> void:
	if !actioning:
		var hide = movechoose($"0/AnimatedSprite2D".animation)
		if hide:
			$"0".hide()


func _on_one_pressed() -> void:
	if !actioning:
		var hide = movechoose($"1/AnimatedSprite2D".animation)
		if hide:
			$"1".hide()


func _on_two_pressed() -> void:
	if !actioning:
		var hide = movechoose($"2/AnimatedSprite2D".animation)
		if hide:
			$"2".hide()


##universal code for the three move buttons
func movechoose(move):
	var hide = false
	match move:
		"defend":
			if energy > 0:
				get_parent().get_node("Player").defend()
				actioning = true
				hide = true
				energy -=1
		"spike":
			if energy > 0:
				hide = true
				energy -=1
				get_parent().get_node("Player").Spike()
				actioning = true
		"gust":
			if energy > 0:
				hide = true
				energy -=1
				get_parent().get_node("Player").Gust()
				actioning = true
		"bewilder":
			if energy > 0 and get_parent().get_node("Player").move != "":
				Global.tama_move.emit()
				hide = true
				energy -=1
				get_parent().get_node("Player").move = ""
				actioning = true
		"fireball":
			if energy > 1:
				hide = true
				energy -=2
				get_parent().get_node("Player").Fireball()
				actioning = true
		"horizon":
			if energy >1:
				hide = true
				energy -=2
				get_parent().get_node("Player").Horizon()
				actioning = true
		"bulwark":
			if energy >2:
				hide = true
				energy -=3
				get_parent().get_node("Player").Bulwark()
				actioning = true
	return hide


func _on_move_finish():
	actioning = false
