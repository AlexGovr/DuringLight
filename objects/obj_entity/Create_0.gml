
position = new Vec2(x, y)
velocity = new Vec2(0, 0)
sp = 5

//// entities
is_player = false
is_building = false
is_resource = false

//// player
action_range = 100
resource_amount = 5
resource_gain = 5

function instance_in_point(pos) {
	return collision_point(pos.X, pos.Y, obj_entity, false, true)
}

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

function build_candle(pos) {
	var inst = collision_point(pos.X, pos.Y, obj_candle, false, true)
	if inst == noone {
		if instance_number(obj_candle) == 0 {
			inst = instance_create_layer(pos.X, pos.Y, layer, obj_candle)
			if !resource_amount
				return false
			resource_amount--
			inst.building.is_burning = true
		} else {
			if global.candles.last.building.building_possible(pos, global.candles.range) {
				if !resource_amount
					return false
				resource_amount--
				inst = instance_create_layer(pos.X, pos.Y, layer, obj_candle)
				global.candles.last.building.next_candle = inst
			} else {
				return false
			}
		}
	}
	global.candles.last = inst
	inst.building.build()
	return true    
}

//// building
building = {
	this: id,
    progress: 0,
    speed: 0.1,
	next_candle: noone,
	burning_left: 360,
	is_burning: false,

    build: function() {
        if self.progress >= 1 {
            return true
		}
        self.progress += self.speed
        this.image_alpha = progress
        return false
    },
	ready: function() {
		return progress >= 1	
	},
	step: function() {
		if !is_burning
			return false
		burning_left--
		if !burning_left {
			if next_candle != noone {
				next_candle.building.is_burning = true
			}
			instance_destroy(this)
		}
	},
	building_possible: function(pos, range) {
		if !self.ready()
			return false
		var lastpos = this.position
		var dist = point_distance(pos.X, pos.Y, lastpos.X, lastpos.Y)
		if dist > range
			return false
		if collision_line(pos.X, pos.Y, lastpos.X, lastpos.Y, obj_block, false, true)
			return false
		return true
	},
	draw: function() {
		var t = this
		draw_text(t.x, t.y, self.burning_left)
		var ds = global.grid_size * 0.5
		if instance_exists(next_candle)
			draw_line_width_color(t.x + ds, t.y + ds, 
								  next_candle.x + ds,
								  next_candle.y + ds, 3, c_yellow, c_yellow)
	}
}

//// resource
resource = {
	this: id,
	mining_cost: 4,
	mine: function() {
		mining_cost--
		if !mining_cost {
			instance_destroy(this)	
			return true
		}
		return false
	}
}

// general
mouse_pos = new Vec2(x, y)
mouse_pos_snapped = mouse_pos.copy().snap_to_grid(global.grid_size)


// late init
alarm[0] = 1