
debug_ini()

shader = {
	u_pos: shader_get_uniform(shd_lighting, "u_pos"),
	u_resolution: shader_get_uniform(shd_lighting, "u_resolution"),
	u_aspect_ratio: shader_get_uniform(shd_lighting, "u_aspect_ratio"),
	cndl_u: 0,
	cndl_v: 0,
}
pause_on = true
surf_view = surface_create(camw()*2, camh()*2)
surf_dark = surface_create(camw()*2, camh()*2)
drawing = true

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
global.candle_sound = audio_play_sound(Candle, 0, true)

function pause() {
	pause_on = true
}

function start() {
	pause_on = false
	with obj_entity { 
		start()
	}
}

function restart() {
	global.frames_since_start = 0
	room_restart()
	start()
}

function game_over() {
	pause()
}

Lighting = {
	this: id,
	draw: function() {
		if this.pause_text_alpha == 0 and global.lighting_on {
			var cndl = global.candles.first
			var shader = this.shader
			var surf_view = this.surf_view
			var surf_dark = this.surf_dark

			surface_copy(surf_view, 0, 0, application_surface)
			if instance_exists(cndl) {
				shader.cndl_u = (cndl.x - camx()) / camw()
				shader.cndl_v = (cndl.y - camy()) / camh()
				shader_set_uniform_f(shader.u_pos, shader.cndl_u, shader.cndl_v)
				shader_set_uniform_f(shader.u_resolution, camw(), camh())
				shader_set_uniform_f(shader.u_aspect_ratio, camh() / camw())
			}
			shader_set(shd_lighting)
			draw_surface_stretched(surf_view, camx(), camy(), camw(), camh())
			shader_reset()

			// draw dark with lights
			//surface_set_target(surf_dark)
			//var c = c_black
			//draw_set_alpha(1)
			//draw_rectangle_color(0, 0, camw(), camh(), c, c, c, c, false)
			//draw_set_alpha(1)
			//if instance_exists(cndl) {
			//	gpu_set_blendmode(bm_subtract)
			//	var xx = cndl.x - camx() + 16
			//	var yy = cndl.y - camy() + 16
			//	draw_sprite(spr_light_mask, 0, xx, yy)
			//	// draw smaller candles
			//	cndl = cndl.building.next_candle
			//	while instance_exists(cndl) {
			//		var xx = cndl.x - camx() + 16
			//		var yy = cndl.y - camy() + 16
			//		draw_sprite_ext(spr_light_mask_small, 0, xx, yy, 0.25, 0.25, 0, c_white, 1)
			//		cndl = cndl.building.next_candle
			//	}
			//	gpu_set_blendmode(bm_normal)
			//}
			//surface_reset_target()
			//draw_surface(surf_dark, camx(), camy())
		}	
	}
}

Tutorial = {
	this: obj_ronny,
	phase: 0,
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

UI = {
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

