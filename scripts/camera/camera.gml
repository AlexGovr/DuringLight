
function camera_set_pos(id, x, y) {
	var cam = view_camera[id]
	camera_set_view_pos(cam,
						x-camera_get_view_width(cam)*0.5,
						y-camera_get_view_height(cam)*0.5)
}

function camw(ind=0) {
	return camera_get_view_width(view_camera[ind])
}

function camh(ind=0) {
	return camera_get_view_height(view_camera[ind])
}

function camx(ind=0) {
	return camera_get_view_x(view_camera[ind])
}

function camy(ind=0) {
	return camera_get_view_y(view_camera[ind])
}

function camx_cent(ind=0) {
	return camera_get_view_x(view_camera[ind]) + camw(ind) * 0.5
}

function camy_cent(ind=0) {
	return camera_get_view_y(view_camera[ind]) + camh(ind) * 0.5
}

function point_in_camera(xx, yy, ind=0) {
	var cx = camx(ind), cy = camy(ind)
	return (xx > cx) and (xx < (cx + camw(ind)))
		   and (yy > cy) and (yy < (cy + camy(ind)))
}
