
//if !surface_exists(surf) exit

//surface_copy_part(surf, 0, 0, application_surface, 0, 0, w*2, h*2)

//shader_set(shd_lighting)
//draw_surface_stretched(surf, 0, 0, w, h)
//shader_reset()

draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, foreground_alpha)
if foreground_alpha == 1 {
	draw_text_custom(camx_cent(), camy_cent(), pause_text, fnt, fa_center, fa_middle)
	draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, (1-pause_text_alpha))
}
