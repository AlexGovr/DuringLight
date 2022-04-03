
//// general
position = new Vec2(x, y)
start_positition = position.copy()
velocity = new Vec2(0, 0)
sp = 2
hp_start = 4
hp = hp_start
mouse_pos = new Vec2(x, y)
mouse_pos_snapped = mouse_pos.copy().snap_to_grid(global.grid_size)
knockback_sp = 6
hit_velocity = new Vec2(0, 0)
attack_on_cooldown = 0
attack_cooldown = 30
highlighted = false
dead = false

//// entities
is_player = false
is_building = false
is_resource = false
is_mob = false
is_hitbox = false
is_hittable = false


function highlight() {
	highlighted = true
}

//// player
action_range = 60
attack_range = 60
resource_amount = 5
resource_gain = 5
anim_hit_time = 10
anim_hit = 0

function start() {
	hp = hp_start
	x = start_positition.X
	y = start_positition.Y
	image_alpha = 1
	dead = false
}

function set_hit(dir) {
	anim_hit = anim_hit_time
	hit_velocity.set_polar(knockback_sp, dir)
	hp--
	if !hp {
		obj_game.game_over()
		dead = true
	}
}

function instance_in_point(pos) {
	var list = ds_list_create()
	collision_point_list(pos.X, pos.Y, obj_entity, false, true, list, false)
	for(var i = 0; i < ds_list_size(list); ++i) {
		var inst = list[| i]
		if !(inst.is_mob and inst.dead)
			return inst
	}
	return noone
}

function build_candle(pos) {
	var inst = collision_point(pos.X, pos.Y, obj_candle, false, true)
	if inst == noone {
		if global.candles.last.building.building_possible(pos, global.candles.range) {
			if !resource_amount
				return false
			resource_amount--
			inst = instance_create_layer(pos.X, pos.Y, "instances", obj_candle)
			global.candles.last.building.next_candle = inst
			global.candles.last.building.burning_speed = 1
		} else {
			return false
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
    speed: 1,
	next_candle: noone,
	burning_left: 360,
	is_burning: false,
    burn_radius: 100,
	burning_speed: 1,

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
		self.burning_left -= self.burning_speed
		if !self.burning_left {
			if next_candle != noone {
				next_candle.building.is_burning = true
			}
            global.candles.first = next_candle
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

//// mob
mob = {
	this: id,
	state: "idle",
	sp: 1,
	sp_slow: 0.5,
	hp: 4,
	hurt_treshold_hp: 2,
	view_range: 250,
	idle_time_base: 180,
	idle_time: 0,
	walk_dist: 100,
    runaway_dist: 240,
	point_to: new Vec2(x, y),
	position: new Vec2(x, y),
	velocity: new Vec2(0, 0),
	hit_dist: 40,
	attack_cooldown: 120,
	attack_on_cooldown: 0,
	attack_target: noone,
	attack_prepare_time: 30,
	attack_preparing: 0,
	anim_hit_time: 2,
	knockback_sp: 6,
	stun_time: 30,
	stunned: 0,

	idle_state: function() {
		self.idle_time = self.idle_time_base
		self.state = "idle"
	},
	walk_state: function() {
		self.state = "walk"
	},
	fight_state: function() {
		self.state = "fight"
	},
    runaway_state: function(cndl) {
        self.state = "runaway"
        self.point_to = self.position.add_polar_(
				self.runaway_dist, point_direction(cndl.x, cndl.y, this.x, this.y))
    },
	move: function(vel=undefined) {
		if vel==undefined
			vel = self.velocity
		self.position.add(velocity)
	},
	dest_reached: function(sp) {
		return point_distance(this.x, this.y, self.point_to.X, self.point_to.Y) < sp
	},
	attack: function(inst) {
		inst.set_hit(point_direction(this.x, this.y, inst.x, inst.y))
		self.attack_on_cooldown = self.attack_cooldown
	},
	set_hit: function(dir) {
		this.anim_hit = self.anim_hit_time
		this.hit_velocity.set_polar(self.knockback_sp, dir)
		self.stunned = self.stun_time
		self.hp--
		if !self.hp
			this.dead = true
	},
    feels_hurt: function() {
        return self.hp <= self.hurt_treshold_hp
    },
	search_attack_target: function() {
		
	}
}

// late init
alarm[0] = 1
