extends CharacterBody2D

@onready var bersek_walk: AnimationPlayer = %BersekWalk
@onready var hit_box: Area2D = $HitBox
@onready var checkpoints: Node2D = $"../Checkpoints"
@onready var fov_cone: Node2D = $FOVCone
@onready var ray_left: RayCast2D = $FOVCone/RayLeft
@onready var ray_center: RayCast2D = $FOVCone/RayCenter
@onready var ray_right: RayCast2D = $FOVCone/RayRight


enum State { PATROLLING , CHASING , RETREATING }
var current_state = State.PATROLLING

var speed = 75.0
var player = null

var checkpoint_index = 0
var checkpoint_list = []
var lair_position = Vector2(900, 300)

func _ready() -> void:
	for cp in checkpoints.get_children():
		checkpoint_list.append(cp.global_position)
	%BersekWalk.play("walk")
	await get_tree().process_frame
	await  get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	MissionManager.boss_mode_started.connect(_on_boss_mode)



func _physics_process(delta: float) -> void:
	if Global.is_player_safe:
		current_state = State.RETREATING
	match current_state:
		State.PATROLLING:
			_patrol(delta)
			_check_fov()
		State.CHASING:
			_chase(delta)
		State.RETREATING:
			_retreat(delta)

func _patrol(_delta) -> void:
	if checkpoint_list.is_empty():
		return
	var target = checkpoint_list[checkpoint_index]
	var direction = (target - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	if direction.x < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false
	
	if global_position.distance_to(target) < 10.0:
		checkpoint_index = (checkpoint_index + 1 ) % checkpoint_list.size()

func _chase(_delta) -> void:
	if Global.is_player_safe:
		current_state = State.RETREATING
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if direction.x < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false


func _retreat(_delta) -> void:
	var direction = (lair_position - global_position).normalized()
	
	velocity = direction * speed * 0.6
	move_and_slide()
	
	if direction.x < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false
	if global_position.distance_to(lair_position) < 20.0:
		current_state = State.PATROLLING



func _check_fov() -> void:
	if velocity.length() > 0:
		fov_cone.rotation = velocity.angle()
	for ray in [ray_left, ray_center, ray_right]:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider and collider.is_in_group("player"):
				current_state = State.CHASING
				return

var hit_cooldown = false

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if hit_cooldown:
			return
		hit_cooldown = true
		print("hit detected, parent is:", get_parent().name)
		get_parent().lose_life()
		await get_tree().create_timer(0.1).timeout
		hit_cooldown = false


func teleport_to(pos :Vector2) -> void:
	await get_tree().create_timer(0.5).timeout
	global_position = pos
	current_state = State.CHASING


func _on_boss_mode() -> void:
	speed *= 1.6
	print("boss mode recieved by berserk")
	print("berserk state is now :", current_state)
	current_state = State.CHASING
	
