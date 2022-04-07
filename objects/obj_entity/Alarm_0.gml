

if is_building {
	if global.frames_since_start == 0 {
		building.is_burning = true
		building.progress = 1
		image_alpha = 1
		global.candles.last = id
        global.candles.first = id
	}
	if object_index == obj_altar_candle {
		with instance_create_layer(x, y - LastLight.height, "instances", obj_last_light)
			LastLight.source_candle = obj_altar_candle
	}
}