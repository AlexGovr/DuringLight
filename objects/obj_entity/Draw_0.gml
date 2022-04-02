
draw_self()

if is_player {
	if point_dist(mouse_pos.X, mouse_pos.Y) < action_range {
		draw_sprite(spr_cursor, 0, mouse_pos_snapped.X, mouse_pos_snapped.Y)
	}
}
