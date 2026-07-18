extends Node
var diai = 0
var dialogue = [[],[]]
var rng = RandomNumberGenerator.new()
@onready var spots = $enemypositions.get_used_cells()
var enemies_finished = 0
var enemcount = 4
var dead = false
var enemies_attacked = 0
var finish = false

# Pause menu stuff
var paused = false
@onready var pause_menu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.enemies_alive = 0
	enemcount = Global.enemy_count
	if Global.coins == -1:
		$Dialogue.show()
		$Mainhud.hide()
		Global.coins = 0
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
	Global.enemy_attack_finish.connect(_on_enemy_attack_finished)
	var rand_range = 3
	if Global.enemy_count >4:
		rand_range+=1
	for x in range(0,Global.enemy_count):
		if spots.size()>0:
			Global.enemies_alive+=1
			match rng.randi_range(1,rand_range):
				1:
					var scene = preload("res://Scenes/enemy.tscn")
					var instance = scene.instantiate()
					var i =rng.randi_range(0, len(spots)-1)
					instance.set_position(spots[i]*120)
					spots.remove_at(i)
					add_child(instance)
				2:
					var scene = preload("res://Scenes/Bones.tscn")
					var instance = scene.instantiate()
					var i =rng.randi_range(0, len(spots)-1)
					instance.set_position(spots[i]*120)
					spots.remove_at(i)
					add_child(instance)
				3:
					var scene = preload("res://Scenes/enemy.tscn")
					var instance = scene.instantiate()
					var i =rng.randi_range(0, len(spots)-1)
					instance.set_position(spots[i]*120)
					spots.remove_at(i)
					add_child(instance)
				4:
					var scene = preload("res://Scenes/berserker.tscn")
					var instance = scene.instantiate()
					var i =rng.randi_range(0, len(spots)-1)
					instance.set_position(spots[i]*120)
					spots.remove_at(i)
					add_child(instance)
	Global.enemy_calculate_move.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (enemies_finished >= Global.enemies_alive) and enemies_finished>0 and !dead:
		$Mainhud.reset()
		$Player.movedecide()
		enemies_attacked=0
		enemies_finished = 0
		Global.enemy_calculate_move.emit()
	if (enemies_attacked >= Global.enemies_alive) and enemies_attacked > 0 and !dead:
		enemies_attacked=0
		Global.enemy_walk_start.emit()
	if Global.enemies_alive == 0 and !finish:
		finish = true
		$win.play()
	if dead and !finish:
		finish = true
		$Dialogue.show()
		$Dialogue/Next.hide()
		$lose.play()
		$theme.stop()
		$Dialogue/Body.text = "I'm sorry, I let you down :( now the world is doomed. If only I'd learnt more spells"
		$Dialogue/Title.text = "You"
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
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
	
	Global.enemy_move.emit()

func _on_enemy_finished():
	enemies_finished+=1

func _on_enemy_attack_finished():
	enemies_attacked+=1

func _on_theme_finished() -> void:
	$theme.play()


func _on_win_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")


func _on_pause_button_pressed():
	print("PAUSED")
	if paused:
		Engine.time_scale = 1
		pause_menu.hide()
		
	if !paused:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
