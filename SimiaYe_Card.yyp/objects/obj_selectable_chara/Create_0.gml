if(!variable_global_exists("object_being_clicked")) {
	global.object_being_clicked = false
}
chara_clicked = false

/// @desc						Draws the highlight behind this character.
///									NOTE this can only be used in the draw events
function draw_character_highlight() {
	draw_set_colour(c_dkgray)
	gpu_set_blendmode(bm_add)
	var sprite_center_x = x - sprite_get_xoffset(sprite_index) + (sprite_width / 2)
	var sprite_center_y = y - sprite_get_yoffset(sprite_index) + (sprite_width / 2)

	for (var dist_from_center = 0; dist_from_center < highlight_radius; dist_from_center++) {
		var circle_alpha = ((highlight_intensity * highlight_radius) /
							((2 * dist_from_center) + highlight_radius)) -
							(highlight_intensity / 3)
		draw_set_alpha(circle_alpha)
	
		var radius = (sprite_width / 2) + dist_from_center
		var left = sprite_center_x - radius 
		var right = sprite_center_x + radius
		var top = sprite_center_y - radius
		var bottom = sprite_center_y + radius
		draw_ellipse(left, top, right, bottom, false)
	}

	gpu_set_blendmode(bm_normal)
	draw_set_alpha(1)
}