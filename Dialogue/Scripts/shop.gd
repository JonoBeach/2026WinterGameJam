extends Node
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var oneArr = ["defend","defend","gust","spike"]
	var twoArr = ["gust","spike","bewilder","horizon"]
	var threeArr = ["bulwark","fireball","horizon"]
	$"NewSpells/0/AnimatedSprite2D".play(oneArr[rng.randi_range(0,3)])
	$"NewSpells/1/AnimatedSprite2D".play(twoArr[rng.randi_range(0,3)])
	$"NewSpells/2/AnimatedSprite2D".play(threeArr[rng.randi_range(0,2)])
	Global.coins = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_win_pressed() -> void:
	if Global.coins >= 20:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")


func _on_continue_pressed() -> void:
	Global.Moves.sort()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_remove_spell_pressed() -> void:
	Global.Moves.sort()
	$MainButtons.hide()
	$CurrentSpells.show()
	for i in range(0,10):
		if i < Global.Moves.size():
			get_node("CurrentSpells/"+str(i)).show()
			get_node("CurrentSpells/"+str(i)+"/AnimatedSprite2D").play(Global.Moves[i])
		else:
			get_node("CurrentSpells/"+str(i)).hide()

func done():
	$CurrentSpells.hide()
	$NewSpells.hide()
	$MainButtons.show()


func _on_exit_pressed() -> void:
	done()


func _on__pressed() -> void:
	if Global.coins>=1 and Global.Moves.size()<10:
		Global.coins-=1
		Global.Moves.append(str($"NewSpells/0/AnimatedSprite2D".animation))
		$"NewSpells/0".hide()

func _on_one_pressed() -> void:
	if Global.coins>=2 and Global.Moves.size()<10:
		Global.coins-=2
		Global.Moves.append(str($"NewSpells/1/AnimatedSprite2D".animation))
		$"NewSpells/1".hide()


func _on_two_pressed() -> void:
	if Global.coins>=3 and Global.Moves.size()<10:
		Global.coins-=3
		Global.Moves.append(str($"NewSpells/2/AnimatedSprite2D".animation))
		$"NewSpells/2".hide()


func _on_gain_spell_pressed() -> void:
	$MainButtons.hide()
	$NewSpells.show()
