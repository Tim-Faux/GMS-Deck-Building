#macro BOOKMARK_PADDING 1

book_bookmarks = [obj_settings_bookmark, obj_settings_bookmark]

bookmarks_layer = layer_create(depth - 1, "bookmarks_layer")
active_page_layer = layer_create(depth - 2, "active_page_layer")
bookmark_bottom_layer = layer_create(depth - 3, "bookmark_bottom_layer")
cover_nine_slice = sprite_get_nineslice(sprite_index)
page_x_pos = x
page_y_pos = y + cover_nine_slice.top

//Not subtracting the left nineslice because we want the pages to meet exactly in the middle
page_width = sprite_width  - cover_nine_slice.right
page_height = sprite_height - cover_nine_slice.bottom - cover_nine_slice.top
bookmark_scale = page_width / (10 * sprite_get_width(spr_settings_bookmark_top))
create_bookmarks()

/// @desc								Creates each of the bookmarks in book_bookmarks, evenly
///											spaced at the top of the book
function create_bookmarks() {
	var bookmark_width = (sprite_get_width(spr_settings_bookmark_top) * bookmark_scale)
	var bookmark_x_pos = page_x_pos - page_width
	var bookmark_y_pos = page_y_pos - (sprite_get_height(spr_settings_bookmark_top) * bookmark_scale)
	
	for(var bookmark_index = 0; bookmark_index < array_length(book_bookmarks); bookmark_index++) {
		bookmark_x_pos += bookmark_width + (BOOKMARK_PADDING * image_xscale)
		instance_create_layer(bookmark_x_pos, bookmark_y_pos, bookmarks_layer, book_bookmarks[bookmark_index], { 
			image_xscale : bookmark_scale,
			image_yscale : bookmark_scale,
			on_bookmark_pressed : method(self, create_chapter),
			page_height,
			bookmark_bottom_layer : bookmark_bottom_layer
		})
	}
}

/// @desc								Creates an instance of the given chapter after clearing any
///											previously created chapters
/// @param {Asset.GMObject} chapter		The chapter object that will be created
/// @param {Real} bookmark_x_pos		The x position of the selected bookmark
function create_chapter(chapter, bookmark_x_pos) {
	delete_layers(find_layers_above(active_page_layer), bookmark_bottom_layer)
	layer_destroy_instances(active_page_layer)
	
	var page_x_scale = page_width / sprite_get_width(sprite_index)
	var page_y_scale = page_height / sprite_get_height(sprite_index)
	instance_create_layer(page_x_pos, page_y_pos, active_page_layer, chapter, {
		image_xscale : page_x_scale,
		image_yscale : page_y_scale
	})
	add_bookmark_bottom(bookmark_x_pos)
}

/// @desc								Adds an obj_bookmark_bottom to the clicked bookmark overtop
///											the left page
/// @param {Real} bookmark_x_pos		The x position to place the bookmark bottom
function add_bookmark_bottom(bookmark_x_pos) {
	if(instance_number(obj_bookmark_bottom) > 0) {
		obj_bookmark_bottom.x = bookmark_x_pos
	}
	else {
		var bookmark_bottom_y_scale = 0.5 * page_height / sprite_get_height(object_get_sprite(obj_bookmark_bottom))
		var bookmark_bottom_y_pos = page_y_pos
		instance_create_layer(bookmark_x_pos, bookmark_bottom_y_pos, bookmark_bottom_layer, obj_bookmark_bottom, {
			image_xscale : bookmark_scale,
			image_yscale : bookmark_bottom_y_scale
		})
	}
}