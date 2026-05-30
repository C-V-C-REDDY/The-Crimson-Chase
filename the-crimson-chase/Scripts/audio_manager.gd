extends Node


func reset_audio() -> void:
	%Boss.stop()
	%In_Game_Bgm.stop()
	%In_Game_Bgm.volume_db = 0.0
	%Boss.volume_db = 0.0
	play_in_game_bgm()


func play_menu_bgm():
	%In_Game_Bgm.stop()
	%Game_Bgm.play()


func play_in_game_bgm():
	%Game_Bgm.stop()
	%In_Game_Bgm.play()

func switch_to_boss_bgm() -> void:
	var tween = create_tween()
	tween.tween_property(%In_Game_Bgm, "volume_db", -40.0, 1.0)
	await tween.finished
	%In_Game_Bgm.stop()
	%Boss.volume_db = -40.0
	%Boss.play()
	var tween2 = create_tween()
	tween2.tween_property(%Boss, "volume_db", 0.0 , 1.0)



func stop_bgm():
	%Game_Bgm.stop()
	%In_Game_Bgm.stop()


func play_hurt():
	%Hurt_Sfx.play()


func play_mc_walk():
	%MC_Wals_Sfx.play()


func stop_mc_walk():
	%MC_Wals_Sfx.stop()

func play_key_sfx():
	%Key_Sfx.play()


func play_safe_zone_sfx():
	%Safe_Zone_Sfx.play()


func play_berserk_laugh():
	%Berserk_Skill_Sfx.play()
	await get_tree().create_timer(3.0).timeout
	%Berserk_Skill_Sfx.play()
	await get_tree().create_timer(3.0).timeout
	%Berserk_Skill_Sfx.play()
	await get_tree().create_timer(3.0).timeout
	%Berserk_Skill_Sfx.play()
	await get_tree().create_timer(3.0).timeout
	%Berserk_Skill_Sfx


func play_stealth_sfx():
	%Stealth_Sfx.play()


func play_berserk_walk_sfx():
	%Berserk_Walk_Sfx.play()


func stop_berserk_walk():
	%Berserk_Walk_Sfx.stop()


func is_footstep_berserk_playing() -> bool:
	return %Berserk_Walk_Sfx.playing


func play_pooring_claim():
	%Pooring_claim_Sfx.play()


func play_bell_sfx():
	%Bell.play()


func play_tap_sfx():
	%Tap.play()


func play_checkpoint_sfx():
	%Cpoint.play()
