extends Node2D

@export var board_message = "Warning!!"
@onready var area_2d: Area2D = $Area2D

var triggered = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.name == "Player":
		triggered = true
	get_tree().get_first_node_in_group("game").warning_toast(board_message)
