extends Node

func play_menu_bgm():
	%In_Game_Bgm.stop()
	%Game_Bgm.play()


func play_in_game_bgm():
	%Game_Bgm.stop()
	%In_Game_Bgm.play()


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
