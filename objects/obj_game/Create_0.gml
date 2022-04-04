
debug_ini()

shader = {
	candle_pos: shader_get_uniform(shd_lighting, "candle_pos"),
	cndl_u: 0,
	cndl_v: 0,
}
pause_on = true
restarting = false
screen_darkening = 0
surf = surface_create(camw()*2, camh()*2)
surf_dark = surface_create(camw()*2, camh()*2)

foreground_alpha = 1
foreground_alpha_pause_treshold = 1
foreground = surface_create(camw(), camh())
surface_set_target(foreground)
var c = c_black
draw_rectangle_color(0, 0, camw(), camh(), c, c, c, c, false)
surface_reset_target()

pause_text_alpha = 0
pause_text_alpha_start_treshold = 0.25
pause_text = "Press any key to watch world's agony"

alpha_ratio = 0.007
alpha_ratio_reverse = 0.015 

audio_set_master_gain(slash, global.slash_sound_gain_on_miss)
//audio_play_sound(Scarry, 0, true)
var snd = audio_play_sound(Ambient, 0, true)
audio_sound_gain(snd, 0.1, 0)
global.candle_sound = audio_play_sound(Candle, 0, true)

function pause() {
	pause_on = true
}

function start() {
	pause_on = false
	with obj_entity { 
		start()
	}

	//if !instance_number(obj_altar_candle) {
	//	var info = start_info.altar_candle
	//	var inst = instance_create_layer(info.X, info.Y, "instances", obj_altar_candle)
	//	global.candles.restart(inst)
	//}
}

function restart() {
	global.frames_since_start = 0
	//instance_destroy(obj_candle)
	//instance_destroy(obj_altar_candle)
	//restarting = true
	//screen_darkening = 1
	room_restart()
	start()
}

function game_over() {
	pause()
}
