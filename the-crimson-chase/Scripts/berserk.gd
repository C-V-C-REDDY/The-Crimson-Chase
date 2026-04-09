extends CharacterBody2D

@onready var bersek_walk: AnimationPlayer = %BersekWalk
@onready var hit_box: Area2D = $HitBox

var speed = 100.0
var player = null

func _ready() -> void:
	%BersekWalk.play("walk")
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	if Global.is_player_safe:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed 
	
	if direction.x < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false
	move_and_slide()




func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("hit detected, parent is:", get_parent().name)
		get_parent().lose_life()
