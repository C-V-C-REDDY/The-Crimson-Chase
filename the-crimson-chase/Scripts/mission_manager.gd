extends Node

signal mission_complete
signal boss_mode_started
signal game_complted

enum Phase { HUNT, TRANSITION, BOSS, END }

var current_phase = Phase.HUNT
var hunt_timer = 150.0
var boss_timer = 30.0
var hunt_active = false
var boss_active = false

func _ready() -> void:
	start_hunt()

func reset() -> void:
	current_phase = Phase.HUNT
	hunt_timer = 150.0
	boss_timer = 30.0
	hunt_active = false
	boss_active = false
	AudioManager.reset_audio()

func start_hunt() -> void:
	reset()
	hunt_active = true
	current_phase = Phase.HUNT


func _process(delta: float) -> void:
	match current_phase:
		Phase.HUNT:
			_process_hunt(delta)
		Phase.TRANSITION:
			pass
		Phase.BOSS:
			_process_boss(delta)


func _process_hunt(delta) -> void:
	if not hunt_active:
		return
	
	hunt_timer -= delta
	Global.hunt_time_remaining = hunt_timer
	
	if Global.keys_collected >= 5 and Global.checkpoints_collected >= 5:
		_hunt_complete()


func _process_boss(delta) -> void:
	if not boss_active:
		return
	boss_timer -= delta
	Global.boss_time_remaining = boss_timer
	if boss_timer <= 0.0:
		_boss_complete()


func _hunt_complete() -> void:
	if not hunt_active:
		return
	hunt_active = false
	current_phase = Phase.TRANSITION
	emit_signal("mission_complete")


func begin_boss_mode() -> void:
	if boss_active:
		return
	AudioManager.switch_to_boss_bgm()
	current_phase = Phase.BOSS
	boss_active = true
	print("phase is :", current_phase)
	print("phase is: ", boss_active)
	emit_signal("boss_mode_started")
	


func _boss_complete() -> void:
	AudioManager.play_in_game_bgm()
	boss_active = false
	current_phase = Phase.END
	emit_signal("game_complted")
