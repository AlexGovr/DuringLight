
resource = {
	ui_x: 45,
	ui_y: -45,
	text_dx: 50,
	X: function() { return camx(0) + self.ui_x },
	Y: function() { return camy(0) + camh(0) + self.ui_y},
	draw: function() {
		var xx = self.X()
		var yy = self.Y()
		draw_sprite(spr_resource, 0, xx, yy)
		draw_text(xx + self.text_dx, yy, obj_ronny.resource_amount)
	},
	draw_gui: function() {
		debug_show_var("ui x:", X())
		debug_show_var("ui y:", Y())
	}
}