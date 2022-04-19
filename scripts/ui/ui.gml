function UiSlider(_spr, _width, _min, _max,
				  initial_val, xx, yy,
				  _collision_raduis=-1) constructor {
	spr = _spr
	sprw = sprite_get_width(spr)
	sprh = sprite_get_height(spr)
	correction_x = sprw * 0.5
	correction_y = sprh * 0.5
	width = _width
	total_width = width + sprite_get_width(spr)
	min_value = _min
	max_value = _max
	value = clamp(initial_val, min_value, max_value)
	collision_raduis = _collision_raduis
	if collision_raduis == -1 {
		// set raduis via sprite size
		collision_raduis = sprite_get_height(spr)  * 0.5
		show_debug_message("Info: UiSlider: collision_raduis set via sprite size: "
						   + string(collision_raduis) + " px")
	}

	X = xx
	Y = yy
	slider_rel_x = X + width * abs(value) / (max_value - min_value)
	is_held = false

	function set_pos(xx, yy) {
		X = xx
		Y = yy
	}

	function is_captured() {
		return (point_distance(get_slider_x(), Y, mouse_x, mouse_y) < collision_raduis)
			   and mouse_check_button_pressed(mb_left)
	}
	
	function get_value() {
		return (max_value - min_value) * slider_rel_x / width
	}
	
	function set_value(val) {
		value = clamp(val, min_value, max_value)
		slider_rel_x = (val - min_value) * width
	}
	
	function get_slider_x() {
		return X + slider_rel_x	
	}
	
	function step() {
		if !is_held  {
			if is_captured() {
				is_held = true
			}
		} else {
			slider_rel_x = clamp(mouse_x - X, 0, width)
			if mouse_check_button_released(mb_left) {
				is_held = false
			}
		}
	}
	
	function draw() {
		draw_sprite_stretched(spr, 0, 
							  X - correction_x,
							  Y - correction_y,
							  total_width, 
							  sprite_get_height(spr))
		draw_sprite_stretched(spr, 1, 
							  get_slider_x() - correction_x, 
							  Y - correction_y, 
							  sprw, 
							  sprh)
	}
}