extends CanvasLayer
var rng = RandomNumberGenerator.new()
#variables for tamadachi movesets
var moves = Global.Moves.duplicate()
var avaiMoves = []
var discards = []
var actioning = false
var energy = 3
var descriptions = [[],[]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var f = FileAccess.open("res://Dialogue/Spells.txt",FileAccess.READ).get_as_text()
	f = f.replace("\n","|").split("|")
	for x in range(0,len(f),2):
		descriptions[0].append(f[x])
		if x < len(f)-1:
			descriptions[1].append(f[x+1])
	assignMoves()
	Global.tama_move.connect(_on_move_finish)

func _process(delta: float) -> void:
	$Energy/EnergyLabel.text = str(energy)+"/3"
	#print(moves)
	$Spells/SpellLabel.text = str(moves.size())+"/"+str(Global.Moves.size())
	$Coins/CoinLabel.text = str(Global.coins)

func _on_end_turn_pressed() -> void:
	if !actioning:
		$"0".hide()
		$"1".hide()
		$"2".hide()
		actioning = true
		get_parent().endturn()
		$EndTurn.hide()

func reset():
	actioning = false
	$EndTurn.show()
	energy=3
	assignMoves()


##generates three moves for the player out of their possible options
func assignMoves():

	discards+=avaiMoves
	avaiMoves = []
	
	
	for i in range(0,3):
		if moves.size() < 1:
			moves+=discards
			discards = []
		var index = rng.randi_range(0,moves.size()-1)
		get_node(str(i)).show()
		get_node(str(i)+"/AnimatedSprite2D").play(moves[index])
		avaiMoves.append(moves[index])
		moves.remove_at(index)
	#print(moves, avaiMoves, discards)

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
				actioning = true
				get_parent().get_node("Player").defend()
				hide = true
				energy -=1
		"spike":
			if energy > 0:
				actioning = true
				hide = true
				energy -=1
				get_parent().get_node("Player").Spike()
		"gust":
			if energy > 0:
				actioning = true
				hide = true
				energy -=1
				get_parent().get_node("Player").Gust()
		"bewilder":
			if energy > 0 and get_parent().get_node("Player").move != "":
				actioning = true
				Global.tama_move.emit()
				hide = true
				energy -=1
				get_parent().get_node("Player").move = ""
		"fireball":
			if energy > 1:
				actioning = true
				hide = true
				energy -=2
				get_parent().get_node("Player").Fireball()
		"horizon":
			if energy >1:
				hide = true
				actioning = true
				energy -=2
				get_parent().get_node("Player").Horizon()
		"bulwark":
			if energy >2:
				actioning = true
				hide = true
				energy -=3
				get_parent().get_node("Player").Bulwark()
	return hide


func _on_move_finish():
	await get_tree().create_timer(1.5).timeout
	actioning = false


func DescSet(spell):
	var ind = 0
	match spell:
		"defend":
			ind = 0
		"gust":
			ind = 1
		"spike":
			ind = 2
		"bewilder":
			ind = 3
		"horizon":
			ind = 4
		"fireball":
			ind = 5
		"bulwark":
			ind = 6
	$Description/Body.text = descriptions[1][ind]
	$Description/Title.text = descriptions[0][ind]

func _on__mouse_exited() -> void:
	$Description.hide()


func _on_zero_mouse_entered() -> void:
	$Description.show()
	$Description.position.x = 680
	DescSet($"0/AnimatedSprite2D".animation)
	


func _on_one_mouse_entered() -> void:
	$Description.show()
	$Description.position.x = 830
	DescSet($"1/AnimatedSprite2D".animation)


func _on__mouse_entered() -> void:
	$Description.show()
	$Description.position.x = 980
	DescSet($"2/AnimatedSprite2D".animation)
