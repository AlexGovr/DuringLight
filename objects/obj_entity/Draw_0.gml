
col = c_white
if highlighted
	col = c_blue
if anim_hit
	var col = make_color_rgb(anim_hit/anim_hit_time, 0, 0)
draw_sprite_ext(sprite_index, 0, x, y, 
				image_xscale, image_yscale,
				image_angle, col, image_alpha)

if is_player {
	if point_dist(mouse_pos.X, mouse_pos.Y) < action_range {
		draw_sprite(spr_cursor, 0, mouse_pos_snapped.X, mouse_pos_snapped.Y)
	}
	draw_text_above_me(hp)
}

if is_building {
	building.draw()
}

highlighted = false
