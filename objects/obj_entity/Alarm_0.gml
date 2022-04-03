
//// init
if is_player {
	switch (global.candle_type) {
		case Candle.snake: {
			global.candles.range = global.grid_size
			break
		}
		case Candle.net: {
			global.candles.range = global.candles_net_range
			break
		}
	}
}

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