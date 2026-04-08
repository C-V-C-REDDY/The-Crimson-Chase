extends Area2D

@onready var key_animation: AnimationPlayer = %KeyAnimation
var collected = false
signal key_collected

func _ready() -> void:
	%KeyAnimation.play("idle")



func _on_body_entered(body):
	if body.name == "Player" and not collected:
		collected = true
		key_collected.emit()
		queue_free()
