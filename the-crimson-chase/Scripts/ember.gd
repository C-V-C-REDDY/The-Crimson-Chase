extends Area2D

signal ember_collected
var collected = false


func _ready() -> void:
	%AnimationPlayer.play("idle")

func _on_body_entered(body: Node2D) -> void:
	AudioManager.play_pooring_claim()
	if body.name == "Player" and not collected:
		collected = true
		ember_collected.emit()
		queue_free()
