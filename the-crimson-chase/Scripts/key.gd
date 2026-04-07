extends Area2D

@onready var key_animation: AnimationPlayer = %KeyAnimation

signal key_collected

func _ready() -> void:
	%KeyAnimation.play("idle")



func _on_body_entered(body):
	if body.name == "Player":
		key_collected.emit()
		queue_free()
