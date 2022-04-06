
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
pause_text = "Press any key to watch the last light dying"

alpha_ratio = 0.007
alpha_ratio_reverse = 0.015 

audio_set_master_gain(slash, global.slash_sound_gain_on_miss)
//audio_play_sound(Scarry, 0, true)
//var snd = audio_play_sound(Ambient, 0, true)
//audio_sound_gain(snd, 0.1, 0)
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


tutorial = {
	this: obj_ronny,
	phase: 0,
	time: 0,
	alpha: 1,
	alpha_ratio: 0.005,
	draw: function() {
		switch phase {
			case 0: {
				var oil = instance_nearest(this.x, this.y, obj_resource)
				if point_distance(this.x, this.y, oil.x, oil.y) < 100 {
					draw_sprite(spr_tute_mb, 0, oil.x, oil.y - 30)
					draw_text_custom(oil.x, oil.y - 50, "Gather", fnt, fa_center, fa_middle)
				}
				break
			}
			case 1: {
				if this.highlight_building {
					draw_sprite(spr_tute_mb, 1, mouse_x, mouse_y - 36)
					draw_text_custom(mouse_x, mouse_y - 70, "Build candlestick", fnt, fa_center, fa_middle)
					if mouse_check_button_pressed(mb_right) {
						phase++
						alpha = 0
					}
				}
				break
			}
			case 2: {
				draw_set_alpha(alpha)
				draw_text_custom(this.x, this.y + 100, "Fight your way through darkness", fnt, fa_center, fa_middle)
				draw_set_alpha(1)
				alpha += alpha_ratio
				if alpha >= 1
					alpha_ratio *= -1
				if alpha_ratio < 0 and alpha <= 0 {
					alpha = 0
					alpha_ratio *= -1
					phase++
				}
				break
			}
			case 3: {
				draw_set_alpha(alpha)
				draw_text_custom(this.x, this.y + 100, "Don't let the last candle die", fnt, fa_center, fa_middle)
				draw_set_alpha(1)
				alpha += alpha_ratio
				if alpha >= 1
					alpha_ratio *= -1
				if alpha_ratio < 0 and alpha <= 0 {
					alpha_ratio *= -1
					phase++
				}
				break
			}
			case 4: {
				
				break
			}
			case 5: {
				
				break
			}
			case -1: {
				
				break
			}
		}
	}
}

ui = {
	draw: function() {
		var x0 = 20
		var y0 = 320
		var i = 0
		var dx = 24
		var yy = camy() + y0
		repeat obj_ronny.hp {
			var xx = camx() + x0 + i * dx
			draw_sprite(spr_heart, 0, xx, yy)
			i++
		}
		i = 0
		var y0 = 340
		var yy = camy() + y0
		repeat obj_ronny.resource_amount {
			var xx = camx() + x0 + i * dx
			draw_sprite(Oil, 0, xx, yy)
			i++
		}	
	}
}

