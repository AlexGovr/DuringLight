global.game_paused = true
global.frames_since_start = 0
global.lighting_on = true
global.creature_animation_speed = 1.5
global.shadows_alpha = 0.7
global.shadows_scale = 1.3

global.candles_net_range = 200
enum Candle {
	snake,
	net,
}
global.candle_type = Candle.net
global.candles = {
	first: noone,
    last: noone,
	range: -1,
	restart: function(first) {
		self.first = first
		self.last = first
	}
}
