extends CanvasLayer
var rng = RandomNumberGenerator.new()
#variables for tamadachi movesets
var moves = Global.Moves.duplicate()
var avaiMoves = []
var discards = []
var actioning = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assignMoves()
	Global.tama_move.connect(_on_move_finish)

func _on_end_turn_pressed() -> void:
	get_parent().endturn()
	$EndTurn.hide()

func reset():
	$EndTurn.show()
	assignMoves()


##generates three moves for the player out of their possible options
func assignMoves():

	discards+=avaiMoves
	avaiMoves = []
	if moves.size() < 3:
		moves.assign(discards)
		discards = []
	
	for i in range(0,3):
		var index = rng.randi_range(0,moves.size()-1)
		get_node(str(i)).show()
		get_node(str(i)+"/AnimatedSprite2D").play(moves[index])
		avaiMoves.append(moves[index])
		moves.remove_at(index)

func _on_button_pressed() -> void:
	if !actioning:
		match $"0/AnimatedSprite2D".animation:
			"defend":
				get_parent().get_node("Player").defend()
				actioning = true
			"spike":
				get_parent().get_node("Player").Spike()
				actioning = true
			"gust":
				get_parent().get_node("Player").Gust()
				actioning = true
		$"0".hide()


func _on_one_pressed() -> void:
	if !actioning:
		match $"1/AnimatedSprite2D".animation:
			"defend":
				get_parent().get_node("Player").defend()
				actioning = true
			"spike":
				get_parent().get_node("Player").Spike()
				actioning = true
			"gust":
				get_parent().get_node("Player").Gust()
				actioning = true
		$"1".hide()


func _on_two_pressed() -> void:
	if !actioning:
		match $"2/AnimatedSprite2D".animation:
			"defend":
				get_parent().get_node("Player").defend()
				actioning = true
			"spike":
				get_parent().get_node("Player").Spike()
				actioning = true
			"gust":
				get_parent().get_node("Player").Gust()
				actioning = true
		$"2".hide()

func _on_move_finish():
	actioning = false
