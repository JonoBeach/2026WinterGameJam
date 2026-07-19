extends Node
var rng = RandomNumberGenerator.new()
var dialogue = [["Tamadachi", "Tamadachi", "Tamadachi", "Tamadachi", "Tamadachi", "Tamadachi"], ["We took care of those guys, now we need to take care of me :)", "If you feed me I\'ll have enough energy to learn a new spell :) But I can only learn a total of 10 spells :(", "And every time you bathe me I feel so refreshed that I forget whatever spell you tell me to ^.^", "Although, I can\'t face my mum if I don\'t know at least 3 spells :( so I won\'t forget any past that point >:(", "If you make enough money I can grow big and strong and have enough power to burst us out of here :)", "And of course once you\'ve properly cared for me we can continue deeper into the dungeon"]]
var descriptions = [["Defend", "Gust", "Spike Trap", "Bewilder", "Event Horizon", "Fireball", "Bulwark", "Phase"], ["Place a shield in a cardinal direction of the knight.", "Pushes all entities in surrounding tiles away from it.", "Place down a spike trap that kills anything that touches it.", "Distract the knight and prevent him from doing his next action.", "Pulls all entities in surrounding tiles towards it.", "Kills everything in its tile and surrounding tiles.", "Places a shield in every direction of the knight.", "Muster all your power to teleport the knight to a nearby tile."]]
var diai = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.enemy_count == 4:
		$MainButtons.hide()
		$Dialogue.show()
	else:
		$MainButtons.show()
		$Dialogue.hide()
	var oneArr = ["gust","defend","gust","spike"]
	var twoArr = ["spike","bewilder","horizon"]
	var threeArr = ["bulwark","fireball","teleport"]
	$"NewSpells/0/AnimatedSprite2D".play(oneArr[rng.randi_range(0,3)])
	$"NewSpells/1/AnimatedSprite2D".play(twoArr[rng.randi_range(0,2)])
	$"NewSpells/2/AnimatedSprite2D".play(threeArr[rng.randi_range(0,2)])
	#var f = FileAccess.open("res://Dialogue/Spells.txt",FileAccess.READ).get_as_text()
	#f = f.replace("\n","|").split("|")
	#for x in range(0,len(f),2):
		#descriptions[0].append(f[x])
		#if x < len(f)-1:
			#descriptions[1].append(f[x+1])
	#f = FileAccess.open("res://Dialogue/Shop.txt",FileAccess.READ).get_as_text()
	#f = f.replace("\n","|").split("|")
	#for x in range(0,len(f),2):
		#dialogue[0].append(f[x])
		#if x < len(f)-1:
			#dialogue[1].append(f[x+1])
	$Dialogue/Title.text = dialogue[0][diai]
	$Dialogue/Body.text = dialogue[1][diai]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Spells/SpellLabel.text = str(Global.Moves.size())+"/10"
	$Coins/CoinLabel.text = str(Global.coins)


func _on_win_pressed() -> void:
	if Global.coins >= 20:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")


func _on_continue_pressed() -> void:
	Global.Moves.sort()
	Global.enemy_count+=3
	Global.enemies_alive = 0
	Global.occupied = []
	Global.spikes = []
	Global.shields = [] 
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
		$eat.play()
		$Tamadachi.play("eat")

func _on_one_pressed() -> void:
	if Global.coins>=2 and Global.Moves.size()<10:
		Global.coins-=2
		Global.Moves.append(str($"NewSpells/1/AnimatedSprite2D".animation))
		$"NewSpells/1".hide()
		$eat.play()
		$Tamadachi.play("eat")


func _on_two_pressed() -> void:
	if Global.coins>=3 and Global.Moves.size()<10:
		Global.coins-=3
		Global.Moves.append(str($"NewSpells/2/AnimatedSprite2D".animation))
		$"NewSpells/2".hide()
		$eat.play()
		$Tamadachi.play("eat")


func _on_gain_spell_pressed() -> void:
	$MainButtons.hide()
	$NewSpells.show()

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
		"teleport":
			ind = 7
	$Description/Body.text = descriptions[1][ind]
	$Description/Title.text = descriptions[0][ind]

func _on__mouse_exited() -> void:
	$Description.hide()


func _on_zero_mouse_entered() -> void:
	$Description.show()
	DescSet($"NewSpells/0/AnimatedSprite2D".animation)
	$Description/Body.text += "\n(1G)"


func _on_one_mouse_entered() -> void:
	$Description.show()
	DescSet($"NewSpells/1/AnimatedSprite2D".animation)
	$Description/Body.text += "\n(2G)"


func _on_two_mouse_entered() -> void:
	$Description.show()
	DescSet($"NewSpells/2/AnimatedSprite2D".animation)
	$Description/Body.text += "\n(3G)"


func _on_win_mouse_entered() -> void:
	$MainButtons/Win/description.show()


func _on_gain_spell_mouse_entered() -> void:
	$MainButtons/GainSpell/description.show()


func _on_remove_spell_mouse_entered() -> void:
	$MainButtons/RemoveSpell/description.show()


func _on_continue_mouse_entered() -> void:
	$MainButtons/Continue/description.show()


func _on_continue_mouse_exited() -> void:
	$MainButtons/Win/description.hide()
	$MainButtons/Continue/description.hide()
	$MainButtons/GainSpell/description.hide()
	$MainButtons/RemoveSpell/description.hide()


func _on_next_pressed() -> void:
	diai +=1
	if diai < len(dialogue[0]):
		$Dialogue/Title.text = dialogue[0][diai]
		$Dialogue/Body.text = dialogue[1][diai]
	else:
		$Dialogue.hide()
		$MainButtons.show()


func _on_theme_finished() -> void:
	$theme.play()


func _on_tamadachi_animation_finished() -> void:
	$Tamadachi.play("Idle")
