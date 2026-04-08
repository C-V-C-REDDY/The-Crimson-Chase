extends Node

@onready var player: CharacterBody2D = %Player

var key_scene = preload("res://Scenes/key.tscn")
var keys_collected = 0
var max_keys = 10
var spawn_timer = 30.0
var game_timer = 600.0
var current_key = null

func _ready() -> void:
	spawn_key()

func _process(delta: float) -> void:
	game_timer -= delta
	spawn_timer -= delta
	
	if game_timer <= 0:
		game_over()
	
	if spawn_timer <= 0:
		spawn_key()


func spawn_key():
	if current_key != null:
		current_key.queue_free()
	
	var key = key_scene.instantiate()
	var rand_x = randf_range(100, 1000)
	var rand_y = randf_range(50, 600)
	key.global_position = Vector2(rand_x, rand_y)
	key.key_collected.connect(_on_key_collected)
	add_child(key)
	current_key = key
	spawn_timer = 30.0


func _on_key_collected():
	keys_collected += 1
	current_key = null
	if keys_collected >= max_keys:
		win()
	else:
		spawn_key()


func win():
	get_tree().paused = true
	%Win.visible = true
	print("You Win!")


func game_over():
	get_tree().paused = true
	%GameOver.visible = true
	print("Game Over!")


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	



func _on_lose_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
