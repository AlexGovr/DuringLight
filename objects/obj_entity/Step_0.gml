
if is_player {
	if keyboard_check_pressed(vk_escape)
		game_end()
	if keyboard_check_pressed(vk_f3)
		room_restart()
	if keyboard_check_pressed(vk_f11)
		window_set_fullscreen(!window_get_fullscreen())
	key_left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	key_right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	key_up = keyboard_check(ord("W")) or keyboard_check(vk_up)
	key_down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	key_interact = keyboard_check_pressed(ord("E"))
	key_interact_hold = keyboard_check(ord("E"))
	key_create_module = keyboard_check_pressed(ord("Q"))
	key_action_pressed = mouse_check_button_pressed(mb_left)
	key_action = mouse_check_button(mb_left)
	mouse_pos.set(mouse_x, mouse_y)
	mouse_pos_snapped = mouse_pos.copy().snap_to_grid(global.grid_size)

	up_free = place_empty(x, y - 1, obj_block)
	down_free = place_empty(x, y + 1, obj_block)
	left_free = place_empty(x - 1, y, obj_block)
	right_free = place_empty(x + 1, y, obj_block)

	//// movement
	input_h = key_right - key_left
	input_v = key_down - key_up
	move_h = key_right * right_free - key_left * left_free
	move_v = key_down * down_free - key_up * up_free
	
	var input = abs(input_h) or abs(input_v)
	if input {
		input_dir = point_direction(0, 0, move_h, move_v)
		velocity.set_polar(sp, input_dir)
	} else {
        velocity.set(0, 0)
    }

	if (velocity.X > 0) and !right_free or (velocity.X < 0) and !left_free
		velocity.X = 0
	if (velocity.Y > 0) and !down_free or (velocity.Y < 0) and !up_free
		velocity.Y = 0
    
    if key_action and (point_dist(mouse_pos.X, mouse_pos.Y) < action_range) {
        build_candle(mouse_pos_snapped)
	}
}

scr_move_coord_contact_obj(velocity.X, velocity.Y, obj_block)
if is_player
	scr_camera_set_pos(0, x, y)

//// building
if is_building {
	building.step()
}
