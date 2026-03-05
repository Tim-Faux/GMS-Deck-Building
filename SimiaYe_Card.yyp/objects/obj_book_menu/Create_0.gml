var cover_nine_slice = sprite_get_nineslice(sprite_index)
page_x_pos = x
page_y_pos = y + cover_nine_slice.top

//Not subtracting the left nineslice because we want the pages to meet exactly in the middle
page_width = sprite_width  - cover_nine_slice.right
page_height = sprite_height - cover_nine_slice.bottom - cover_nine_slice.top

page_x_scale = page_width / sprite_get_width(sprite_index)
page_y_scale = page_height / sprite_get_height(sprite_index)

var active_page_layer = layer_create(depth - 1)
active_page = instance_create_layer(page_x_pos, page_y_pos, active_page_layer, obj_settings_chapter, {
	image_xscale : page_x_scale,
	image_yscale : page_y_scale
})

/// @desc						Draws a spr_cover and a flipped spr_cover, each the size of this object
///									with x being the center between them. Then draws sprite_index over
///									each of them
function draw_cover() {
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
	draw_sprite_ext(spr_page, 0, page_x_pos, page_y_pos, page_x_scale, page_y_scale,
							image_angle, image_blend, image_alpha)
						
	draw_sprite_ext(sprite_index, 0, x, y, -image_xscale, image_yscale, image_angle, image_blend, image_alpha)
	draw_sprite_ext(spr_page, 0, page_x_pos, page_y_pos, -page_x_scale, page_y_scale, 
							image_angle, image_blend, image_alpha)	
}