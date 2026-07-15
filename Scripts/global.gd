extends Node
var Moves = ["defend","defend","defend","gust","gust","spike"]
signal gust_check() #for both gust and spike buttons visibility setting
var spots
var playerpos
signal tama_move() #for when player chooses where they're doing their move
var spikes = [] #stores current positions of spikes
var shields = [] #stores current positions of shields
var coins = 0
signal player_move_finish()
signal enemy_move_finish()
signal enemy_dead()
