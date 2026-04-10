extends Node

var key_scene = preload("res://Scenes/key.tscn")
var keys_collected = 0
var max_keys = 2
var spawn_timer = 30.0
var game_timer = 600.0
var current_key = null
var ember_speed_boost = 20.0
var next_ember_threshold = 5
var ember_scene = preload("res://Scenes/ember.tscn")
var invincible = false
@onready var camera = $Player/Camera2D

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
	if keys_collected >= next_ember_threshold:
		next_ember_threshold += 5
		get_tree().paused = true
		%EmberPrompt.visible = true
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
	Global.reset()
	get_tree().reload_current_scene()


func _on_lose_restart_pressed() -> void:
	get_tree().paused = false
	Global.reset()
	get_tree().reload_current_scene()


func lose_life():
	if Global.lives <= 0:
		return
	if invincible:
		return
	invincible = true
	print("lives before:", Global.lives)
	Global.lives -= 1
	screen_shake(8.0, 0.3)
	print("lives after:", Global.lives)
	if Global.lives == 2:
		%Heart3.visible = false
	elif Global.lives == 1:
		%Heart2.visible = false
	elif Global.lives == 0:
		%Heart1.visible = false
		game_over()
	await get_tree().create_timer(2.0).timeout
	invincible = false



#func _on_player_hit():
	#if not Global.is_player_safe:
		#lose_life()


func _on_yes_btn_pressed() -> void:
	%EmberPrompt.visible = false
	get_tree().paused = false
	spawn_ember()
	berserk_speed_up()
	spawn_key()

func spawn_ember():
	var ember = ember_scene.instantiate()
	var player = get_tree().get_first_node_in_group("player")
	ember.global_position = Vector2(
		player.global_position.x + randf_range(-80, 80),
		player.global_position.y + randf_range(-80, 80)
	)
	ember.ember_collected.connect(_on_ember_collected)
	add_child(ember)

func _on_ember_collected():
	var buff = randi() % 3
	match  buff:
		0: apply_heal()
		1: apply_stealth()
		2: apply_speed_boost()


func _on_no_btn_pressed() -> void:
	%EmberPrompt.visible = false
	get_tree().paused = false
	spawn_key()


func berserk_speed_up():
	var berserk = get_tree().get_first_node_in_group("berserk")
	if berserk:
		berserk.speed += ember_speed_boost


func apply_heal():
	if Global.lives < 3:
		Global.lives += 1
		match Global.lives:
			1:
				%Heart1.visible = true
			2:
				%Heart2.visbile = true
			3:
				%Heart3.visible = true


func apply_stealth():
	Global.is_player_safe = true
	await get_tree().create_timer(10.0).timeout
	Global.is_player_safe = false


func apply_speed_boost():
	var player = get_tree().get_first_node_in_group("player")
	var original_speed = player.speed
	player.speed = original_speed * 2.0
	await get_tree().create_timer(10.0).timeout
	player.speed = original_speed


func screen_shake(amount: float, duration: float):
	var timer = duration
	while timer > 0:
		camera.offset = Vector2(randf_range(-amount, amount), randf_range(-amount, amount))
		timer -= get_process_delta_time()
		await get_tree().process_frame
	camera.offset = Vector2.ZERO
