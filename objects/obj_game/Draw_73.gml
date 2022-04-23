
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
var u_radiuses = shader_get_uniform(shader, "u_radiuses")
var u_brightness = shader_get_uniform(shader, "u_brightness")
var u_blue_add = shader_get_uniform(shader, "u_blue_add")
shader_set_uniform_f(u_resolution, cw, ch)
shader_set_uniform_f(u_mouse, umx*window_scale, umy*window_scale)
shader_set_uniform_f(u_aspect_ratio, uar)
shader_set_uniform_f_array(u_radiuses, shader_data.u_radiuses)
shader_set_uniform_f_array(u_brightness, shader_data.u_brightness)
shader_set_uniform_f_array(u_blue_add, shader_data.u_blue_add)
if drawing {
	draw_surface_stretched(surf_view, cx, cy, cw, ch)
}
shader_reset()

draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, foreground_alpha)
if foreground_alpha == 1 {
	draw_text_custom(camx_cent(), camy_cent(), pause_text, fnt, fa_center, fa_middle)
	draw_surface_ext(foreground, camx(), camy(), 1, 1, 0, c_white, (1-pause_text_alpha))
}

for(var i = 0; i < array_length(shader_data.u_radiuses); i++) {
	var slider = ui_sliders_r[i]
	slider.draw()
}
for(var i = 0; i < array_length(ui_sliders_br); i++) {
	var slider = ui_sliders_br[i]
	slider.draw()
}
for(var i = 0; i < array_length(ui_sliders_bl); i++) {
	var slider = ui_sliders_bl[i]
	slider.draw()
}
