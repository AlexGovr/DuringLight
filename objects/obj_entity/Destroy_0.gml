
if is_player and instance_exists(obj_ui)
	instance_destroy(obj_ui)
if is_mob {
	instance_destroy(hitbox)
}
if is_building {
	var sid = audio_play_sound(Crack, 0, false)
	audio_sound_gain(sid, max(global.candle_sound_gain, global.candle_sound_die_min_gain), 0)
}

if is_resource {
	if obj_game.tutorial.phase == 0
		obj_game.tutorial.phase++
}
