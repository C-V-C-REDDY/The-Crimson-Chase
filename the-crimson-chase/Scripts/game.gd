extends Node

var key_scene = preload("res://Scenes/key.tscn")
var keys_collected = 0
var keys_count = 0
var pooring_count = 0
var max_keys = 2
var spawn_timer = 3.0
var game_timer = 300.0
var current_key = null
var ember_speed_boost = 20.0
var invincible = false
@onready var camera = $Player/Camera2D
var ember_pooring_scene = preload("res://Scenes/ember_pooring.tscn")
var ember_timer = 60.0
var ember_elapsed = 0.0
var toast_offset = 0
var safe_spawn_points = []
var used_positions = []
var mission_timer = 100
var mission_active = false
var mission_start_delay = 5.0
var mission_elapsed = 0.0
@onready var toast_label: Label = $HUD/ToastLabel


func _ready() -> void:
	AudioManager.play_in_game_bgm()
	for point in %SpawnPonits.get_children():
		safe_spawn_points.append(point.global_position)
	spawn_key()
	AudioManager.play_berserk_walk_sfx()
	

func _process(delta: float) -> void:
	game_timer -= delta
	spawn_timer -= delta
	ember_elapsed += delta
	if ember_elapsed >= ember_timer:
		ember_elapsed = 0.0
		_spawn_ember_pooring()
	#if game_timer <= 0:
		#win()
	if not mission_active:
		mission_start_delay -= delta
		if mission_start_delay <= 0:
			mission_active = true
			Global.mission_active = true
			%MissionBg.visible = true
			%MissionLabel.visible = true
			%TimerLabel.visible = true
			
	if mission_active:
		mission_elapsed += delta
		var time_left = int(mission_timer - mission_elapsed)
		%TimerLabel.text = str(time_left)
		if time_left <= 0 and keys_count < max_keys:
			mission_failed()
			%TimerLabel.visible = false
	if keys_count >= max_keys and mission_active:
		mission_complete()
		%TimerLabel.visible = false
			
	if spawn_timer <= 0:
		spawn_key()

func mission_complete():
	mission_active = false
	Global.mission_active = false
	Global.player_frozen = false
	%MissionLabel.text = "Mission Complete!!"
	%TimerLabel.text = "Congratulations"
	await get_tree().create_timer(3).timeout
	%MissionLabel.visible = false
	%MissionBg.visible = false
	#%TimerLabel.visible = false
	#print("Mission COmplete")


func mission_failed():
	mission_active = false
	Global.mission_active = false
	%MissionLabel.text = "Mission Failed!"
	Global.player_frozen = true
	Global.lives = 1


func _spawn_ember_pooring():
	var ep = ember_pooring_scene.instantiate()
	ep.global_position = _random_floor_position()
	ep.ember_claimed.connect(_on_ember_claimed)
	call_deferred("add_child", ep)
	show_toast("Elite Pooring Spawned!")


func _on_ember_claimed(pos):
	used_positions.erase(pos)
	pooring_count += 1
	%pooringcount.text = "X" + str(pooring_count)
	berserk_speed_up()
	var roll = randi() % 3
	match roll:
		0: apply_heal() 
		1: apply_stealth()
		2: apply_speed_boost()



func spawn_key():
	if current_key != null:
		used_positions.erase(current_key.global_position)
		current_key.queue_free()
	var key = key_scene.instantiate()
	key.global_position = _random_floor_position()
	call_deferred("add_child", key)
	current_key = key
	key.keys_collected.connect(_on_key_collected)
	spawn_timer = 3.0

func _on_key_collected():
	keys_count += 1
	%Keys_count.text = "X" + str(keys_count)
	#if keys_count >= 2 and mission_active:
		#mission_complete()


func win():
	get_tree().paused = true
	%Win.visible = true
	%LivesAnim.play("Win")
	print("You Win!")


func game_over():
	get_tree().paused = true
	%GameOver.visible = true
	%LivesAnim.play("game_over")
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
	AudioManager.play_hurt()
	screen_shake(8.0, 0.3)
	print("lives after:", Global.lives)
	if Global.lives == 2:
		%LivesAnim.play("H1")
		%Heart3.visible = false
	elif Global.lives == 1:
		%LivesAnim.play("H2")
		%Heart2.visible = false
	elif Global.lives == 0:
		%LivesAnim.play("H3")
		%Heart1.visible = false
		game_over()
	await get_tree().create_timer(2.0).timeout
	invincible = false



func berserk_speed_up():
	show_toast("Berserk Speed Up!!")
	var berserk = get_tree().get_first_node_in_group("berserk")
	if berserk:
		berserk.speed += ember_speed_boost


func apply_heal():
	show_toast("Healed!")
	if Global.lives < 3:
		Global.lives += 1
		match Global.lives:
			1:
				%Heart1.visible = true
			2:
				%Heart2.visible = true
			3:
				%Heart3.visible = true


func get_random_spawn():
	var available = safe_spawn_points.filter(func(p): return p not in used_positions)
	if available.is_empty():
		used_positions.clear()
		available = safe_spawn_points
	var pos = available[randi() % available.size()]
	used_positions.append(pos)
	return pos



func _random_floor_position() -> Vector2:
	return get_random_spawn()


func apply_stealth():
	show_toast("Stealth Mode!")
	Global.is_player_safe = true
	await get_tree().create_timer(10.0).timeout
	Global.is_player_safe = false


func apply_speed_boost():
	show_toast("Speed Boost!")
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


func show_toast(message: String):
	var label = Label.new()
	label.text = message
	label.position = Vector2(500, 250 + toast_offset)
	get_tree().get_first_node_in_group("hud").add_child(label)
	toast_offset += 25
	var tween = create_tween()
	tween.tween_property(label, "position:y", label.position.y -40, 0.9)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.9)
	await tween.finished
	label.queue_free()
	toast_offset -= 25


func warning_toast(message: String):
	toast_label.text = ""
	toast_label.visible = true
	for character in message:
		toast_label.text += character
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(3).timeout
	toast_label.visible = false
