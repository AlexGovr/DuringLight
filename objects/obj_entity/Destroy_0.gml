
if is_player and instance_exists(obj_ui)
	instance_destroy(obj_ui)
if is_mob {
	instance_destroy(hitbox)
}