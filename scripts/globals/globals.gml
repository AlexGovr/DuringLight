global.game_paused = true
global.frames_since_start = 0
global.lighting_on = true

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
}
