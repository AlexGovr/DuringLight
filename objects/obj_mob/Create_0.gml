/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited()

is_mob = true
is_hittable = true
hitbox = instance_create_layer(x, y, "instances", obj_mob_hitbox)
hitbox.target = id
anim_set = anim_set_orc
anim_attack_set = anim_attack_orc
