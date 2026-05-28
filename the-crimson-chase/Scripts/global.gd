extends Node

var is_player_safe = false
var lives = 3
var keys_collected = 0
var mission_active = false
var player_frozen = false
var checkpoints_collected = 0
var checkpoints_total = 5
var hunt_time_remaining = 150.0
var boss_time_remaining = 30.0

func reset():
	lives = 3
	is_player_safe = false
	keys_collected = 0
	mission_active = false
	player_frozen = false
	checkpoints_collected = 0
	hunt_time_remaining = 150.0
	boss_time_remaining = 30.0
