///@arg speed
///@arg dir
function scr_move(sp, dir) {
	x += lengthdir_x(sp, dir)
	y += lengthdir_y(sp, dir)
}

function scr_move_coord(hsp, vsp) {
	x += hsp
	y += vsp
	position.set(x, y)
}

function scr_move_coord_contact_obj(hsp, vsp, obj) {
	scr_move_coord(hsp, vsp)
	var dir = point_direction(0, 0, hsp, vsp)
	//collision
	var contact = instance_place(x, y, obj)
	if contact  {
		// move out of an object
		while place_meeting(x, y, contact) {
	        x -= lengthdir_x(1, dir)
	        y -= lengthdir_y(1, dir)
		}
		return contact
	}
	return noone
}

function scr_move_contact_obj(sp, dir, obj) {
	scr_move(sp, dir)
	//collision
	var contact = instance_place(x, y, obj)
	if contact {
		// move out of an object
		while place_meeting(x, y, contact) {
	        x -= lengthdir_x(1, dir)
	        y -= lengthdir_y(1, dir)
		}
	}
}
