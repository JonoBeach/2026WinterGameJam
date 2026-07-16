extends Node
signal gust_check() #for both gust and spike buttons visibility setting
signal tama_move() #for when player chooses where they're doing their move
signal player_move_finish()
signal enemy_move_finish()
signal enemy_dead()
signal enemy_move()
var Moves = ["defend","defend","defend","gust","gust","spike"]
var spots
var playerpos
var occupied = []
var spikes = [] #stores current positions of spikes
var shields = [] #stores current positions of shields
var coins = 0
var enemy_count = 4
