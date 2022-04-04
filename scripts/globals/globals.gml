
global.game_paused = true
global.frames_since_start = 0
global.lighting_on = true
global.creature_animation_speed = 1.5
global.shadows_alpha = 0.7
global.shadows_scale = 1.3
global.candle_sound = noone
global.candle_sound_dist = 220
global.candle_sound_gain = 1
global.candle_sound_die_min_gain = 0.01
global.slash_sound_gain_on_hit = 0.5
global.slash_sound_gain_on_miss = 0.1

global.candles_net_range = 200
global.candles = {
	first: noone,
    last: noone,
	range: global.candles_net_range,
	restart: function(first) {
		self.first = first
		self.last = first
	}
}
