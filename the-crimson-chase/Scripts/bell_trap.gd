extends Area2D


var triggered = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if not body.is_in_group("player"):
		return
	
	triggered = true
	_summon_berserk()
	%Bell.visible = true
	%bell_anim.play("trap")
	await get_tree().create_timer(5.0).timeout
	%Bell.visible = false


func _summon_berserk() -> void:
	var berserk = get_tree().get_first_node_in_group("berserk")
	if berserk:
		berserk.teleport_to(global_position)
