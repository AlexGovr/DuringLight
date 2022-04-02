
position = new Vec2(x, y)
velocity = new Vec2(0, 0)
sp = 5

//// entities
is_player = false
is_building = false

//// player
action_range = 100

function search_candle_nearby(pos) {
	var i = gridi(pos.X)
	var j = gridj(pos.Y)
	var inst = collision_point(gridx(i-1), pos.Y, obj_candle, false, true)
	if inst { return inst }
	var inst = collision_point(gridx(i+1), pos.Y, obj_candle, false, true)
	if inst { return inst }
	var inst = collision_point(pos.X, gridy(j-1), obj_candle, false, true)
	if inst { return inst }
	var inst = collision_point(pos.X, gridy(j+1), obj_candle, false, true)
	if inst { return inst }
	return noone	
}

function build_candle(mpos) {
    var pos = mpos
    var inst = collision_point(pos.X, pos.Y, obj_candle, false, true)
    if inst == noone {
		var nearby = search_candle_nearby(pos)
		if (nearby and nearby.building.ready())
				or (instance_number(obj_candle) == 0) {
			inst = instance_create_layer(pos.X, pos.Y, layer, obj_candle)
		} else {
			return false
		}
    }
    inst.building.build()
	return true
}

//// building
building = {
	this: id,
    progress: 0,
    speed: 0.03,

    build: function() {
        if self.progress >= 1
            return true
        self.progress += self.speed
        this.image_alpha = progress
        return false
    },
	ready: function() {
		return progress >= 1	
	}
}

// general
mouse_pos = new Vec2(x, y)
mouse_pos_snapped = mouse_pos.copy().snap_to_grid(global.grid_size)


// late init
alarm[0] = 1