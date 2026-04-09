extends Node

var key_scene = preload("res://Scenes/key.tscn")
var keys_collected = 0
var max_keys = 2
var spawn_timer = 30.0
var game_timer = 600.0
var current_key = null
var lives = Global.lives

func _ready() -> void:
	spawn_key()

func _process(delta: float) -> void:
	game_timer -= delta
	spawn_timer -= delta
	
	if game_timer <= 0:
		game_over()
	
	if spawn_timer <= 0 and current_key == null:
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
	spawn_timer = 30.0
	if keys_collected >= max_keys:
		win()
	else:
		spawn_key()


func win():
	get_tree().paused = true
	%Win.visible = true
	%Keys.text = "Keys Collected: " + str(keys_collected)
	print("You Win!")


func game_over():
	get_tree().paused = true
	%GameOver.visible = true
	%key.text = "Keys Collected: " + str(keys_collected)
	print("Game Over!")


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_lose_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func lose_life():
	print("lives before:", Global.lives)
	Global.lives -= 1
	print("lives after:", Global.lives)
	if Global.lives == 2:
		%Heart3.visible = false
	elif Global.lives == 1:
		%Heart2.visible = false
	elif Global.lives == 0:
		%Heart1.visible = false
		game_over()


func _on_player_hit():
	if not Global.is_player_safe:
		lose_life()
