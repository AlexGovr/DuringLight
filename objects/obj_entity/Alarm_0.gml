

if is_building {
    image_alpha = 0

	if global.frames_since_start == 0 {
		building.is_burning = true
		building.progress = 1
		image_alpha = 1
		global.candles.last = id
        global.candles.first = id
	}
}