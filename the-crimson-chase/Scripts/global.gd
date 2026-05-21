extends Node

var is_player_safe = false
var lives = 3
var keys_collected = 0
var mission_active = false
var player_frozen = false
func reset():
	lives = 3
	is_player_safe = false
	keys_collected = 0
	mission_active = false
	player_frozen = false
