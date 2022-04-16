
//Lighting.draw()
UI.draw()
Tutorial.draw()

if keyboard_check_pressed(vk_space)
	drawing = !drawing

cx = camx(0)
cy = camy(0)
cw = camw(0)
ch = camh(0)
umx = (mouse_x - cx)/cw
umy = (mouse_y - cy)/ch
uar = cw/ch
window_scale = window_get_width() / cw

surface_copy(surf_view, 0, 0, application_surface)
var shader = light
shader_set(shader)
var u_resolution = shader_get_uniform(shader, "u_resolution")
var u_mouse = shader_get_uniform(shader, "u_mouse")
var u_aspect_ratio = shader_get_uniform(shader, "u_aspect_ratio")
shader_set_uniform_f(u_resolution, cw, ch)
shader_set_uniform_f(u_mouse, umx*window_scale, umy*window_scale)
shader_set_uniform_f(u_aspect_ratio, uar)
if drawing {
	draw_surface_stretched(surf_view, cx, cy, cw, ch)
}
shader_reset()

draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, foreground_alpha)
if foreground_alpha == 1 {
	draw_text_custom(camx_cent(), camy_cent(), pause_text, fnt, fa_center, fa_middle)
	draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, (1-pause_text_alpha))
}
