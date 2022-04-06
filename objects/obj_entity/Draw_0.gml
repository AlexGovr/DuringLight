
col = c_white
if highlighted
	col = c_blue
if anim_hit
	var col = make_color_rgb(anim_hit/anim_hit_time, 0, 0)

// draw shadows
if (is_player or is_mob) and !dead {
	draw_shadow()
}

if attack_sprite_index {
    draw_sprite(attack_sprite_index, attack_image_index, x, y)
    attack_image_index += sprite_get_speed(attack_sprite_index) * 1.5 / room_speed
	if attack_image_index >= sprite_get_number(attack_sprite_index) {
		attack_sprite_index = noone
		attack_image_index = 0
	}
}

//if is_obstacle {
//	draw_sprite_ext(sprite_index, 1, x, y, 
//				image_xscale, image_yscale,
//				image_angle, col, global.shadows_alpha)
//}

draw_sprite_ext(sprite_index, image_index, x, y, 
				image_xscale, image_yscale,
				image_angle, col, image_alpha)

if object_index == obj_candle
	test = true

if is_player {
	var cndl = global.candles.last
	if point_dist(mouse_pos.X, mouse_pos.Y) < action_range {
		draw_sprite(spr_cursor, 0, mouse_pos_snapped.X, mouse_pos_snapped.Y)
		if highlight_building and instance_exists(cndl) {
			draw_set_alpha(0.5)
			var xx = cndl.x + 16
			var yy = cndl.y + 16
			var xx1 = mouse_pos_snapped.X + 16
			var yy1 = mouse_pos_snapped.Y + 16
			draw_line_width_color(xx, yy, xx1, yy1, 2, c_yellow, c_yellow)
			draw_set_alpha(1)
		}
	}
	//draw_text_above_me(hp)
}

if is_building {
	building.draw()
    if building.is_burning {
        //draw_circle(x, y, building.burn_radius, true)
    }
}

if is_mob {
	//draw_circle(x, y, mob.hit_dist, true)	
}

highlighted = false
