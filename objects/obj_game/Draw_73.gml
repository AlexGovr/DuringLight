
//surface_copy_part(surf, 0, 0, application_surface, camx(), camy(), camw(), camh())
surface_copy(surf, 0, 0, application_surface)
var cndl = global.candles.first

// shade to blue
if pause_text_alpha == 0 and global.lighting_on {
	if instance_exists(cndl) {
		shader.cndl_u = (cndl.x - camx()) / camw()
		shader.cndl_v = (cndl.y - camy()) / camh()
		shader_set_uniform_f(shader.candle_pos, shader.cndl_u, shader.cndl_v)
	}
	shader_set(shd_lighting)
	draw_surface_stretched(surf, camx(), camy(), camw(), camh())
	shader_reset()

	// draw dark with lights
	surface_set_target(surf_dark)
	var c = c_black
	draw_set_alpha(1)
	draw_rectangle_color(0, 0, camw(), camh(), c, c, c, c, false)
	draw_set_alpha(1)
	if instance_exists(cndl) {
		gpu_set_blendmode(bm_subtract)
		var xx = cndl.x - camx() + 16
		var yy = cndl.y - camy() + 16
		draw_sprite(spr_light_mask, 0, xx, yy)
		// draw smaller candles
		cndl = cndl.building.next_candle
		while instance_exists(cndl) {
			var xx = cndl.x - camx() + 16
			var yy = cndl.y - camy() + 16
			draw_sprite_ext(spr_light_mask_small, 0, xx, yy, 0.25, 0.25, 0, c_white, 1)
			cndl = cndl.building.next_candle
		}
		gpu_set_blendmode(bm_normal)
	}
	surface_reset_target()

	draw_surface(surf_dark, camx(), camy())
}

ui.draw()
tutorial.draw()

draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, foreground_alpha)
if foreground_alpha == 1 {
	draw_text_custom(camx_cent(), camy_cent(), pause_text, fnt, fa_center, fa_middle)
	draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, (1-pause_text_alpha))
}
