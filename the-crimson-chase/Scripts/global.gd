extends Node

var is_player_safe = false
var lives = 3
var keys_collected = 0

func reset():
	lives = 3
	is_player_safe = false
	keys_collected = 0
