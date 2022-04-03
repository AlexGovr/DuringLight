
if keyboard_check_pressed(vk_escape)
	game_end()
if keyboard_check_pressed(vk_f3)
	restart()
if keyboard_check_pressed(vk_f11)
	window_set_fullscreen(!window_get_fullscreen())

if global.game_paused {
	if pause_text_alpha >= pause_text_alpha_start_treshold and keyboard_check_pressed(vk_anykey) {
		restart()
	}
}

if pause_on {
	foreground_alpha = approach(foreground_alpha, 1, alpha_ratio * (pause_text_alpha == 0))
	pause_text_alpha = approach(pause_text_alpha, 1, alpha_ratio * (foreground_alpha == 1))
	global.game_paused = foreground_alpha == 1
} else {
	foreground_alpha = approach(foreground_alpha, 0, alpha_ratio * (pause_text_alpha == 0))
	pause_text_alpha = approach(pause_text_alpha, 0, alpha_ratio * (foreground_alpha == 1))
	global.game_paused = !(foreground_alpha < foreground_alpha_pause_treshold)
}
