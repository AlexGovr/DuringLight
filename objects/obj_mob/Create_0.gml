/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited()

is_mob = true
is_hittable = true
hitbox = instance_create_layer(x, y, layer, obj_mob_hitbox)
hitbox.target = id