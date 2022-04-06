
Lighting.draw()
UI.draw()
Tutorial.draw()

draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, foreground_alpha)
if foreground_alpha == 1 {
	draw_text_custom(camx_cent(), camy_cent(), pause_text, fnt, fa_center, fa_middle)
	draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, (1-pause_text_alpha))
}
