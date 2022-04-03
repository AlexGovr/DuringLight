
debug_ini()

pause_on = true

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
	start()
}

function game_over() {
	pause()	
}
