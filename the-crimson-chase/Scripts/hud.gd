extends CanvasLayer

@onready var red_flash: ColorRect = %"red flash"
@onready var b_label: Label = %B_label
@onready var b_timer: Label = %B_timer

func _ready() -> void:
	MissionManager.mission_complete.connect(_on_mission_complete)
	red_flash.visible = false
	b_label.visible = false

func _on_mission_complete() -> void:
	await get_tree().create_timer(1.0).timeout
	_play_transition()

func _play_transition() -> void:
	await get_tree().create_timer(3.0).timeout
	red_flash.visible = true
	await get_tree().create_timer(0.15).timeout
	red_flash.visible = false
	await get_tree().create_timer(0.15).timeout
	red_flash.visible = true
	await get_tree().create_timer(0.15).timeout
	red_flash.visible = false
	await get_tree().create_timer(0.3).timeout
	b_label.visible = true
	await get_tree().create_timer(2.0).timeout
	b_label.visible = false
	b_timer.visible = true
	MissionManager.begin_boss_mode()
