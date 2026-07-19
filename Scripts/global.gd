extends Node
signal gust_check() #for both gust and spike buttons visibility setting
signal tama_move() #for when player chooses where they're doing their move
signal spell_finished()
signal player_move_finish()
signal enemy_move_finish()
signal enemy_dead()
signal enemy_move()
signal enemy_calculate_move()
signal enemy_attack_finish()
signal enemy_walk_start()
signal exit_hide()
var Moves = ["defend","gust","horizon","gust","spike","teleport"]
var spots
var playerpos
var occupied = []
var spikes = [] #stores current positions of spikes
var shields = [] #stores current positions of shields
var coins = 0
var enemy_count = 4
var enemies_alive = 0
