#macro SELECTABLE_CHARA_ARROW_WIDTH 25
#macro SELECTABLE_CHARA_ARROW_SPEED 17
#macro SELECTABLE_CHARA_ARROW_PADDING 5

if(!variable_global_exists("object_being_clicked")) {
	global.object_being_clicked = false
}
chara_clicked = false
is_selected = false
arrow_pos = 0

/// @desc						Draws the highlight behind this character.
///									NOTE this can only be used in the draw events
function draw_character_highlight() {
	draw_set_colour(c_dkgray)
	gpu_set_blendmode(bm_add)
	var sprite_center_x = xstart - sprite_get_xoffset(sprite_index) + (sprite_width / 2)
	var sprite_center_y = ystart - sprite_get_yoffset(sprite_index) + (sprite_width / 2)
	var max_radius = highlight_radius
	if(is_selected) {
		max_radius *= 3 / 4	
	}
	
	for (var dist_from_center = 0; dist_from_center < max_radius; dist_from_center++) {
		var circle_alpha = ((highlight_intensity * max_radius) /
							((2 * dist_from_center) + max_radius)) -
							(highlight_intensity / 3)
		draw_set_alpha(circle_alpha)
	
		var current_radius = (sprite_width / 2) + dist_from_center
		var left = sprite_center_x - current_radius 
		var right = sprite_center_x + current_radius
		var top = sprite_center_y - current_radius
		var bottom = sprite_center_y + current_radius
		draw_ellipse(left, top, right, bottom, false)
	}

	gpu_set_blendmode(bm_normal)
	draw_set_alpha(1)
}

/// @desc						draws an arrow over selected characters to indicate them as selected
///									NOTE this can only be used in the draw events
function draw_arrow_overhead() {
	draw_set_colour(c_yellow)
	draw_set_alpha(1)
	var arrow_movement = abs(sin(arrow_pos / SELECTABLE_CHARA_ARROW_SPEED) * 10)
	var sprite_top = ystart - sprite_get_yoffset(sprite_index)
	
	var arrow_width = SELECTABLE_CHARA_ARROW_WIDTH * image_xscale
	var sprite_center = xstart - sprite_get_xoffset(sprite_index) + (sprite_width / 2)
	var arrow_bottom = sprite_top - SELECTABLE_CHARA_ARROW_PADDING - arrow_movement
	var arrow_top = arrow_bottom - arrow_width
	var arrow_left = sprite_center - (arrow_width / 2)
	var arrow_right = sprite_center + (arrow_width / 2)
	
	var stem_bottom = arrow_top
	var stem_top = arrow_top - (sprite_height / 2)
	
	draw_triangle(arrow_left, arrow_top, arrow_right, arrow_top, sprite_center, arrow_bottom, false)
	draw_line_width(sprite_center, stem_top, sprite_center, stem_bottom, arrow_width / 4)
	arrow_pos++
}