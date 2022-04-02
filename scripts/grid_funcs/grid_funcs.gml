
global.grid_x = 0
global.grid_y = 0
global.grid_size = 32
global.grid_w = 5
global.grid_h = 5
global.grid = noone

function create_grid() {
	global.grid = array_create(global.grid_w)
	for (var i = 0; i < global.grid_w; ++i) {
	    global.grid[i] = array_create(global.grid_h, noone)
	}
}

function gridx(i) {
	return global.grid_x + i * global.grid_size
}

function gridy(j) {
	return global.grid_y + j * global.grid_size
}

function gridi(xx) {
	var diff = xx - global.grid_x
	var correction = diff < 0
	var _x = diff + correction
	return _x div global.grid_size - correction 
}

function gridj(yy) {
	var diff = yy - global.grid_y
	var correction = diff < 0
	var _y = diff + correction
	return _y div global.grid_size - correction 
}

function in_grid_bounds(i, j) {
	return (value_between(i, 0, global.grid_w)
			and value_between(j, 0, global.grid_h))
}

function grid_at(i, j) {
	if not in_grid_bounds(i, j)
		return noone
	return global.grid[i, j]
}

function grid_move_to(i, j, inst) {
	global.grid[inst.i][inst.j] = noone
	global.grid[i][j] = inst
}

function snap_to_grid(inst) {
	var i = gridi(inst.x)
	var j = gridi(inst.y)
	if not in_grid_bounds(i, j)
		throw (" :snap_to_grid: Instance is not in grid bounds")
	inst.x = gridx(i)
	inst.y = gridy(j)
}

create_grid()
