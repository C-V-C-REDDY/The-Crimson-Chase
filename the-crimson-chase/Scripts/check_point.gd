extends Area2D

const  WAIT_TIME = 3.0
const  FADE_ALPHA = 0.3

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var progress_bar: ProgressBar = $ProgressBar

var triggered = false
var player_inside = false
var elapsed = 0.0

func _ready() -> void:
	progress_bar.max_value = WAIT_TIME
	progress_bar.value = 0.0
	progress_bar.visible = false

func _process(delta: float) -> void:
	if triggered or not player_inside:
		return
	
	elapsed += delta
	progress_bar.value = elapsed
	
	if elapsed >= WAIT_TIME:
		_complete()





func _on_body_entered(body: Node2D) -> void:
	if triggered or not body.is_in_group("player"):
		return
	%AnimationPlayer.play("charge")
	player_inside = true
	progress_bar.visible = true


func _on_body_exited(body: Node2D) -> void:
	%AnimationPlayer.pause()
	if triggered or not body.is_in_group("player"):
		return
	player_inside = false
	elapsed = 0.0 
	progress_bar.value = 0.0
	progress_bar.visible = false


func _complete() -> void:
	AudioManager.play_checkpoint_sfx()
	%AnimationPlayer.pause()
	triggered = true
	player_inside = false
	progress_bar.visible = false
	sprite_2d.modulate.a = FADE_ALPHA
	Global.checkpoints_collected += 1
