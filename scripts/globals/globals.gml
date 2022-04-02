global.frames_since_start = 0

global.candles_net_range = 200
enum Candle {
	snake,
	net,
}
global.candle_type = Candle.net
global.candles = {
	last: noone,
	range: -1,
}