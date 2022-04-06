
//// general
up_free = false
down_free = false
left_free = false
right_free = false
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

image_speed = 0

//// entities
is_player = false
is_building = false
is_resource = false
is_mob = false
is_hitbox = false
is_hittable = false
is_obstacle = false

function highlight() {
	highlighted = true
}

//// animation
anim_set_player = [
	sPlayerIdle_strip4,             // 0
	sPlayerMoveRight_strip4,        // 1 r
	sPlayerMoveDown_strip4,         // 2 d
	sPlayerMoveDown_strip4,        // 3 rd
	sPlayerMoveLeft_strip4,         // 4 l
	sPlayerIdle_strip4,             // 5 lr
	sPlayerMoveDown_strip4,         // 6 ld
	sPlayerMoveDown_strip4,         // 7 lrd
	sPlayerMoveUp_strip4,            // 8 u
    sPlayerMoveUp_strip4,           // 9 ur
	sPlayerIdle_strip4,             // 10 ud
	sPlayerIdle_strip4,             // 11 urd
	sPlayerMoveUp_strip4,           // 12 ul
	sPlayerMoveUp_strip4,        // 13 ulr
	sPlayerMoveLeft_strip4,         // 14 uld
	sPlayerIdle_strip4,             // 15 ulrd
]
anim_set_orc = [
	sOrcIdle_strip2,             // 0
	sOrcRight_strip4,        // 1 r
	sOrcDown_strip3,         // 2 d
	sOrcDown_strip3,        // 3 rd
	sOrcLeft_strip4,         // 4 l
	sOrcIdle_strip2,             // 5 lr
	sOrcDown_strip3,         // 6 ld
	sOrcDown_strip3,         // 7 lrd
	sOrcUp_strip6,            // 8 u
    sOrcUp_strip6,           // 9 ur
	sOrcIdle_strip2,             // 10 ud
	sOrcIdle_strip2,             // 11 urd
	sOrcUp_strip6,           // 12 ul
	sOrcUp_strip6,        // 13 ulr
	sOrcLeft_strip4,         // 14 uld
	sOrcIdle_strip2,             // 15 ulrd
]

anim_attack_player = []
anim_attack_player[sPlayerIdle_strip4] = sAttackDown_strip3
anim_attack_player[sPlayerMoveRight_strip4] = sAttackRight_strip3
anim_attack_player[sPlayerMoveDown_strip4] = sAttackDown_strip3
anim_attack_player[sPlayerMoveLeft_strip4] = sAttackLeft_strip3
anim_attack_player[sPlayerMoveUp_strip4] = sAttackUp_strip3

anim_attack_orc = []
anim_attack_orc[sOrcIdle_strip2] = sAttackDown_strip3
anim_attack_orc[sOrcRight_strip4] = sAttackRight_strip3
anim_attack_orc[sOrcDown_strip3] = sAttackDown_strip3
anim_attack_orc[sOrcLeft_strip4] = sAttackLeft_strip3
anim_attack_orc[sOrcUp_strip6] = sAttackUp_strip3

anim_set = undefined
anim_attack_set = undefined
attack_sprite_index = noone
attack_image_index = 0

function animate(vlc, input_active) {
    if !input_active {
		image_speed = sprite_index == sPlayerIdle_strip4 or sprite_index == sOrcIdle_strip2
        return -1
	}
    var r = vlc.X > 0
    var d = vlc.Y > 0
    var l = vlc.X < 0
    var u = vlc.Y < 0
    var index = r + d * 2 + l * 4 + u * 8
    sprite_index = anim_set[index]
	image_speed = 1
    return index
}

function animate_attack() {
    attack_sprite_index = anim_attack_set[sprite_index]
	return audio_play_sound(slash, 0, false)
}

function draw_shadow() {
	draw_sprite_ext(spr_shadow, 0, x, y,
					global.shadows_scale, global.shadows_scale,
					0, c_white, global.shadows_alpha)
}

//// player
action_range = 60
attack_range = 60
resource_amount_start = 5
resource_amount = resource_amount_start
resource_gain = 1
anim_hit_time = 10
anim_hit = 0

function start() {
	hp = hp_start
	x = start_positition.X
	y = start_positition.Y
	image_alpha = 1
	dead = false
	resource_amount = resource_amount_start
	anim_hit = 0
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
		if !(inst.is_mob or inst.dead)
			return inst
	}
	return noone
}

function build_candle(pos) {
	var inst = collision_point(pos.X, pos.Y, obj_candle, false, true)
	if inst == noone {
		if !resource_amount
			return false
		resource_amount--
		inst = instance_create_layer(pos.X, pos.Y, "instances", obj_candle)
		global.candles.last.building.next_candle = inst
		global.candles.last.building.burning_speed = 1
	}
	global.candles.last = inst
	return true
}

//// building
building = {
	this: id,
    progress: 1,
    speed: 1,
	next_candle: noone,
	burning_left: 500,
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
			if !instance_exists(next_candle)
				obj_game.game_over()
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
		//draw_text(t.x, t.y, self.burning_left)
		var ds = global.grid_size * 0.5
		if instance_exists(next_candle) {
			draw_set_alpha(0.25)
			draw_line_width_color(t.x + ds, t.y + ds, 
								  next_candle.x + ds,
								  next_candle.y + ds, 3, c_yellow, c_yellow)
			draw_set_alpha(1)
		}
	}
}

//// resource
resource = {
	this: id,
	mining_cost: 1,
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
    runaway_dist: 120,
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
		if vel == undefined
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
