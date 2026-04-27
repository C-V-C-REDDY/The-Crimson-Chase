extends Area2D

signal zone_shifted

var shift_interval: float = 30.0
var warning_time: float = 5.0
var shift_timer: float = 0.0
var warning_given: bool = false

var spawn_positions: Array = [
	Vector2(250, 200),
	Vector2(500, 200),
	Vector2(750, 200),
	Vector2(250, 324),
	Vector2(500, 324),
	Vector2(750, 324),
	Vector2(250, 450),
	Vector2(500, 450),
	Vector2(750, 450)
]

func _process(delta: float) -> void:
	shift_timer += delta
	
	if shift_timer >= shift_interval - warning_time and not warning_given:
		warning_given = true
		AudioManager.play_safe_zone_sfx()
		%Warning.play("warning")
		print("Warning - SafeZone soon!")
		
	if shift_timer >= shift_interval:
		shift_zone()


func shift_zone():
	shift_timer = 0.0
	warning_given = false
	%Warning.stop()
	get_tree().get_root().get_node("Game").show_toast("Safe Zone Warning!!!")
	var new_pos = spawn_positions[randi() % spawn_positions.size()]
	global_position = new_pos
	emit_signal("zone_shifted")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.is_player_safe = true
		AudioManager.stop_berserk_walk()




func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		Global.is_player_safe = false
	if not AudioManager.is_footstep_berserk_playing():
		AudioManager.play_berserk_walk_sfx()
