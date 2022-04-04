
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

if is_player {
	if point_dist(mouse_pos.X, mouse_pos.Y) < action_range {
		draw_sprite(spr_cursor, 0, mouse_pos_snapped.X, mouse_pos_snapped.Y)
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
