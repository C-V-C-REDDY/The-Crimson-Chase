extends Node2D

signal ember_claimed

func _ready() -> void:
	%AnimationPlayer.play("idl")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("ember_claimed")
		queue_free()
