extends CharacterBody2D

@onready var bersek_walk: AnimationPlayer = %BersekWalk
@onready var hit_box: Area2D = $HitBox

var speed = 100.0
var player = null
var game_timer_ref = 30.0
var slow_unlocked = false
var slow_cooldown = 10.0
var slow_timer = 0.0
var is_slowing = false
var lair_position = Vector2(900, 80)
var is_retreating = false

func _ready() -> void:
	%BersekWalk.play("walk")
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if is_retreating:
		return
	game_timer_ref -= delta
	
	if game_timer_ref <= 30.0:
		slow_unlocked = true
		
	if slow_unlocked:
		slow_timer += delta
		if slow_timer >= slow_cooldown and not is_slowing:
			slow_timer = 0.0
			activate_slow()
		
	if player == null:
		return
	if Global.is_player_safe:
		return
	var direction =(player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	if distance < 80.0:
		var perpenicular = Vector2(-direction.y, direction.x)
		direction = (direction + perpenicular * 0.8).normalized()
	
	velocity = direction * speed 
	
	if direction.x < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false
	move_and_slide()


func activate_slow():
	AudioManager.play_berserk_laugh()
	is_slowing = true
	var original_speed = player.speed
	player.speed = original_speed * 0.4
	print("Berserk activated slow!")
	get_tree().get_root().get_node("Game").show_toast("Berserk's Skill Activated!")
	await get_tree().create_timer(3.0).timeout
	player.speed = original_speed
	is_slowing = false

var hit_cooldown = false

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if hit_cooldown:
			return
		hit_cooldown = true
		print("hit detected, parent is:", get_parent().name)
		get_parent().lose_life()
		retreat_to_lair()
		await get_tree().create_timer(0.1).timeout
		hit_cooldown = false


func retreat_to_lair():
	is_retreating = true
	global_position = lair_position
	await get_tree().create_timer(2.0).timeout
	is_retreating = false
