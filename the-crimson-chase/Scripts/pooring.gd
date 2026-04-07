extends Node2D
@onready var pooring_animation: AnimationPlayer = %PooringAnimation


var follow_target : Node2D = null
var follow_speed = 175.0
var follow_distance = 30

func _ready() -> void:
	%PooringAnimation.play("walk")


func _process(delta: float) -> void:
	if follow_target == null:
		return
	var distance = global_position.distance_to(follow_target.global_position)
	if distance > follow_distance:
		var direction = (follow_target.global_position - global_position).normalized()
		global_position += direction * follow_speed * delta
