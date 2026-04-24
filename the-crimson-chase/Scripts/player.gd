extends CharacterBody2D
@onready var anim_player: AnimationPlayer = $PlayerAnimation
@onready var pooring: Node2D = $"../Pooring"
@onready var mc_wals_sfx: AudioStreamPlayer = %MC_Wals_Sfx


var speed = 200.0

func _ready() -> void:
	anim_player.play("idle")
	pooring.follow_target = self

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	#if velocity != Vector2.ZERO:
		#AudioManager.play_mc_walk()
	#else:
		#AudioManager.stop_mc_walk()

func _process(_delta: float) -> void:
	if velocity != Vector2.ZERO:
		AudioManager.play_mc_walk()
	else:
		AudioManager.stop_mc_walk()
