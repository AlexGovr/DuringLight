
depth = -y
image_alpha = approach(image_alpha, 0, 0.01 * dead)
highlight_building = false

if global.game_paused or dead
	exit

if is_player {
	key_left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	key_right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	key_up = keyboard_check(ord("W")) or keyboard_check(vk_up)
	key_down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	key_interact = keyboard_check_pressed(ord("E"))
	key_interact_hold = keyboard_check(ord("E"))
	key_create_module = keyboard_check_pressed(ord("Q"))
	key_action_pressed = mouse_check_button_pressed(mb_left)
	key_build = mouse_check_button_pressed(mb_right)
	key_action = mouse_check_button(mb_left)
	mouse_pos.set(mouse_x, mouse_y)
	mouse_pos_snapped = mouse_pos.copy().snap_to_grid(global.grid_size)

	//// sound
	var cndl = global.candles.first
	if instance_exists(cndl) {
		global.candle_sound_gain = max(1 - point_dist(cndl.x, cndl.y) / global.candle_sound_dist, 0)
		audio_sound_gain(global.candle_sound, global.candle_sound_gain, 0)
	}

	//// movement
	input_h = key_right - key_left
	input_v = key_down - key_up
	move_h = key_right * right_free - key_left * left_free
	move_v = key_down * down_free - key_up * up_free

	var input = abs(input_h) or abs(input_v)
	if input {
		input_dir = point_direction(0, 0, move_h, move_v)
		velocity.set_polar(sp, input_dir)
	} else {
        velocity.set(0, 0)
    }

	var mdist = point_dist(mouse_pos.X, mouse_pos.Y)
	var action_in_range = mdist < action_range
    var cndl = global.candles.last
	if instance_exists(cndl) {
		if action_in_range and cndl.building.building_possible(mouse_pos_snapped, global.candles.range) {
	        highlight_building = true
			if key_build
				build_candle(mouse_pos_snapped)
		}
	}

	attack_on_cooldown--
	var attack_in_range = mdist < attack_range
	var attack_snd_gain = global.slash_sound_gain_on_miss
	if attack_in_range {
		var inst = instance_in_point(mouse_pos)
		if inst != noone {
			if inst.is_hitbox
				inst = inst.target
			if inst.is_hittable
				inst.highlight()
			if key_action_pressed {
				if inst.is_resource {
					if inst.Resource.mine()
						resource_amount += resource_gain
				}
				if inst.is_mob and !attack_on_cooldown {
					inst.mob.set_hit(point_dir(inst.x, inst.y))
					attack_snd_gain = global.slash_sound_gain_on_hit
				}
			}
		}
	}
	if key_action_pressed and !attack_on_cooldown {
		var snd = animate_attack()
		attack_on_cooldown = attack_cooldown
		audio_sound_gain(snd, attack_snd_gain, 0)
	}
	var vlc = velocity
	if anim_hit {
		vlc = hit_velocity
		anim_hit--
	}
	
	if (vlc.X > 0) and !right_free or (vlc.X < 0) and !left_free
		vlc.X = 0
	if (vlc.Y > 0) and !down_free or (vlc.Y < 0) and !up_free
		vlc.Y = 0

	if abs(vlc.len())
		scr_move_coord_contact_obj(vlc.X, vlc.Y, obj_block)
    animate(vlc, input)
	
	up_free = place_empty(x, y - 1, obj_block)
	down_free = place_empty(x, y + 1, obj_block)
	left_free = place_empty(x - 1, y, obj_block)
	right_free = place_empty(x + 1, y, obj_block)
}

//// building
if is_building {
	building.step()
}

if is_mob {
	mob.position.set(x, y)
	var msp = mob.sp
	var dist = infinity
	if instance_exists(obj_ronny)
		dist = point_dist(obj_ronny.x, obj_ronny.y)
	mob.attack_on_cooldown--
	mob.stunned--
    var cndl = global.candles.first
    if cndl != noone {
        if point_dist(cndl.x, cndl.y) < cndl.building.burn_radius {
            msp = mob.sp_slow
            if mob.feels_hurt()
                mob.runaway_state(cndl)
        }
    }
	if !mob.stunned {
		switch mob.state {
			case "idle": {
				mob.idle_time--
				if !mob.idle_time {
					mob.walk_state()
					mob.point_to.add_polar(mob.walk_dist, random(360))
				}
				if dist < mob.view_range {
					mob.fight_state()
					dest_reached = false
					break
				}
				break
			}
			case "walk": {
				if mob.dest_reached(msp) {
					state = "idle"
					mob.idle_state()
					mob.velocity.set(0, 0)
					break
				}
				if dist < mob.view_range {
					mob.fight_state()
					dest_reached = false
					break
				}
				mob.velocity = mob.point_to.sub_(mob.position).normalized(msp)
				mob.move()
				break
			}
			case "fight": {
				mob.point_to = obj_ronny.position.add_polar_(
					mob.hit_dist, point_direction(obj_ronny.x, obj_ronny.y, x, y))
				if mob.dest_reached(msp) {
					mob.velocity.set(0, 0)
					if mob.attack_prepairing == 0 {
						mob.attack_prepairing = mob.attack_prepare_time
					}
					mob.attack_prepairing--
					if (mob.attack_prepairing == 0) and !mob.attack_on_cooldown {
						mob.attack(obj_ronny)
						animate_attack()
					}
				} else {
					mob.velocity = mob.point_to.sub_(mob.position).normalized(msp)
					mob.attack_prepairing = 0
				}
				mob.move()
				break
			}
	        case "runaway": {
	            if !instance_exists(cndl) {
	                mob.idle_state()
	                break
	            }
	            mob.velocity = mob.point_to.sub_(mob.position).normalized(msp)
				if mob.dest_reached(msp)
					mob.idle_state()
	            break
	        }
		}
	}
	var vlc = mob.velocity
	if mob.stunned
		vlc = new Vec2(0, 0)
	if anim_hit {
		vlc = hit_velocity
		anim_hit--
	}
	scr_move_coord_contact_obj(vlc.X, vlc.Y, obj_block)
	hitbox.x = x
	hitbox.y = y
	var dir_ind = round(vlc.dir() / 45) * 45
	var anim_vlc = new Vec2(1, dir_ind, true)
    animate(anim_vlc, abs(anim_vlc.len()))
}

if is_last_light {
	LastLight.step()	
}
