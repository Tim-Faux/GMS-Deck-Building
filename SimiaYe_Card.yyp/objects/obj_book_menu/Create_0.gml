active_page_layer = layer_create(depth - 1)
create_chapter()

function create_chapter() {
	var cover_nine_slice = sprite_get_nineslice(sprite_index)
	var page_x_pos = x
	var page_y_pos = y + cover_nine_slice.top

	//Not subtracting the left nineslice because we want the pages to meet exactly in the middle
	var page_width = sprite_width  - cover_nine_slice.right
	var page_height = sprite_height - cover_nine_slice.bottom - cover_nine_slice.top

	var page_x_scale = page_width / sprite_get_width(sprite_index)
	var page_y_scale = page_height / sprite_get_height(sprite_index)

	
	instance_create_layer(page_x_pos, page_y_pos, active_page_layer, obj_settings_chapter, {
		image_xscale : page_x_scale,
		image_yscale : page_y_scale
	})
}