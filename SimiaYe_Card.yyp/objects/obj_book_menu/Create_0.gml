#macro BOOKMARK_PADDING 1

book_bookmarks = [obj_settings_bookmark, obj_settings_bookmark]

bookmarks_layer = layer_create(depth - 1)
active_page_layer = layer_create(depth - 2)
cover_nine_slice = sprite_get_nineslice(sprite_index)
page_x_pos = x
page_y_pos = y + cover_nine_slice.top

//Not subtracting the left nineslice because we want the pages to meet exactly in the middle
page_width = sprite_width  - cover_nine_slice.right
page_height = sprite_height - cover_nine_slice.bottom - cover_nine_slice.top
create_bookmarks()

/// @desc								Creates each of the bookmarks in book_bookmarks, evenly
///											spaced at the top of the book
function create_bookmarks() {
	var bookmark_scale = page_width / (10 * sprite_get_width(spr_settings_bookmark_top))
	var bookmark_width = (sprite_get_width(spr_settings_bookmark_top) * bookmark_scale)
	var bookmark_x_pos = page_x_pos - page_width
	var bookmark_y_pos = page_y_pos - (sprite_get_height(spr_settings_bookmark_top) * bookmark_scale)
	
	for(var bookmark_index = 0; bookmark_index < array_length(book_bookmarks); bookmark_index++) {
		bookmark_x_pos += bookmark_width + (BOOKMARK_PADDING * image_xscale)
		instance_create_layer(bookmark_x_pos, bookmark_y_pos, bookmarks_layer, book_bookmarks[bookmark_index], { 
			image_xscale : bookmark_scale,
			image_yscale : bookmark_scale,
			on_bookmark_pressed : method(self, create_chapter)
		})
	}
}

/// @desc								Creates an instance of the given chapter after clearing any
///											previously created chapters
/// @param {Asset.GMObject} chapter		The chapter object that will be created
function create_chapter(chapter) {
	delete_layers(find_layers_above(active_page_layer), [])
	layer_destroy_instances(active_page_layer)
	var page_x_scale = page_width / sprite_get_width(sprite_index)
	var page_y_scale = page_height / sprite_get_height(sprite_index)
	
	instance_create_layer(page_x_pos, page_y_pos, active_page_layer, chapter, {
		image_xscale : page_x_scale,
		image_yscale : page_y_scale
	})
}