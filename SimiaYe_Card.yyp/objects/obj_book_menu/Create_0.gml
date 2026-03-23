#macro BOOKMARK_PADDING 1

book_bookmarks = [ obj_settings_bookmark, obj_cards_bookmark, obj_characters_bookmark ]
bookmark_data = array_create(array_length(book_bookmarks))

bookmarks_layer = layer_create(depth - 1, "bookmarks_layer")
active_page_layer = layer_create(depth - 2, "active_page_layer")
bookmark_bottom_layer = layer_create(depth - 3, "bookmark_bottom_layer")
cover_nine_slice = sprite_get_nineslice(spr_cover)
page_x_pos = x
page_y_pos = y + cover_nine_slice.top
book_opened = false
spr_cover_front = noone
spr_cover_back = noone
cover_surf = surface_create(sprite_width, sprite_height)
create_cover_sprites()

//Not subtracting the left nineslice because we want the pages to meet exactly in the middle
page_width = sprite_width  - cover_nine_slice.right
page_height = sprite_height - cover_nine_slice.bottom - cover_nine_slice.top
bookmark_scale = page_width / (10 * sprite_get_width(spr_settings_bookmark_top))
last_left_bookmark_index = -1
create_bookmarks()

/// @desc								Creates each of the bookmarks in book_bookmarks, evenly
///											spaced at the top of the book
/// @param {Real} start_index			The first instance to delete, defaults to 0
/// @param {Real} end_index				The last instance to delete, defaults to all instances
function create_bookmarks(start_index = 0, end_index = array_length(book_bookmarks) - 1) {
	var bookmark_width = (sprite_get_width(spr_settings_bookmark_top) * bookmark_scale)
	var bookmark_y_pos = page_y_pos - (sprite_get_height(spr_settings_bookmark_top) * bookmark_scale)
	
	for(var bookmark_index = start_index; bookmark_index <= end_index; bookmark_index++) {
		var dist_from_start = (bookmark_width + (BOOKMARK_PADDING * image_xscale)) * (bookmark_index + 1)
		var bookmark_x_pos = last_left_bookmark_index >= bookmark_index ?
									page_x_pos - dist_from_start :
									page_x_pos + dist_from_start
		
		bookmark_data[bookmark_index] = { sprite : object_get_sprite(book_bookmarks[bookmark_index]), x_pos : dist_from_start }
		instance_create_layer(bookmark_x_pos, bookmark_y_pos, bookmarks_layer, book_bookmarks[bookmark_index], { 
			image_xscale : last_left_bookmark_index >= bookmark_index ? -bookmark_scale : bookmark_scale,
			image_yscale : bookmark_scale,
			bookmark_index,
			is_active_bookmark : last_left_bookmark_index == bookmark_index,
			on_bookmark_pressed : method(self, create_chapter)
		})
	}
}

/// @desc								Deletes all the bookmark instances between the given index,
///											including the index
/// @param {Real} start_index			The first instance to delete, defaults to 0
/// @param {Real} end_index				The last instance to delete, defaults to all instances
function delete_bookmarks(start_index = 0, end_index = array_length(book_bookmarks) - 1) {
	var num_bookmarks = instance_number(obj_bookmark)
	start_index = max(0, start_index)
	end_index = min(num_bookmarks - 1, end_index)
	for(var bookmark_index = 0; bookmark_index < num_bookmarks; bookmark_index++) {
		var bookmark_instance = instance_find(obj_bookmark, bookmark_index)
		if(bookmark_instance.bookmark_index >= start_index && 
				bookmark_instance.bookmark_index <= end_index) {
			instance_destroy(bookmark_instance)
			num_bookmarks--
			bookmark_index--
		}
	}
}

/// @desc									Creates an instance of the given chapter after clearing any
///												previously created chapters
/// @param {Asset.GMObject} chapter			The chapter object that will be created
/// @param {Real} bookmark_index_pressed	The index of the bookmark pressed to change the chapter
function create_chapter(chapter, bookmark_index_pressed) {
	delete_layers(find_layers_above(active_page_layer), bookmark_bottom_layer)
	layer_destroy_instances(active_page_layer)
	
	var flip_direction = page_flip_direction.none
	var bookmarks_to_flip = []
	if(last_left_bookmark_index < bookmark_index_pressed) {
		delete_bookmarks(last_left_bookmark_index + 1, bookmark_index_pressed)
		flip_direction = page_flip_direction.left
		
		bookmarks_to_flip = array_create(bookmark_index_pressed - last_left_bookmark_index)
		for(var bookmark_index = 0; bookmark_index < array_length(bookmarks_to_flip); bookmark_index++) {
			bookmarks_to_flip[bookmark_index] = bookmark_data[bookmark_index + last_left_bookmark_index + 1]
		}
	}
	else {
		delete_bookmarks(bookmark_index_pressed + 1, last_left_bookmark_index)
		add_bookmark_bottom(x - bookmark_data[bookmark_index_pressed].x_pos)
		flip_direction = page_flip_direction.right
		
		bookmarks_to_flip = array_create(last_left_bookmark_index - bookmark_index_pressed)
		for(var bookmark_index = 0; bookmark_index < array_length(bookmarks_to_flip); bookmark_index++) {
			bookmarks_to_flip[bookmark_index] = bookmark_data[last_left_bookmark_index - bookmark_index]
		}
	}
	
	var page_x_scale = page_width / sprite_get_width(spr_cover)
	var page_y_scale = page_height / sprite_get_height(spr_cover)
	instance_create_layer(page_x_pos, page_y_pos, active_page_layer, chapter, {
		image_xscale : page_x_scale,
		image_yscale : page_y_scale,
		bookmarks_to_flip,
		bookmark_scale,
		book_is_open : book_opened,
		flip_direction,
		pages_array : {front_sprite : spr_cover_front, back_sprite : spr_cover_back, x_pos : x, y_pos : y, bend_page : false, surface : cover_surf},
		on_cover_opened : method(self, book_finished_opening),
		on_cover_opened_args : [bookmark_index_pressed]
	})
	sprite_index = spr_cover
}

/// @desc									Call back function for obj_page. This updates the sprite and
///												records that the book is now open
/// @param {Real} bookmark_index_pressed	The bookmark pressed to open the book, used in a number of
///												functions to finish the bookmark placement
function book_finished_opening(bookmark_index_pressed) {
	sprite_index = spr_cover
	global.object_being_clicked = false
	book_opened = true
	var max_left_bookmark_index = last_left_bookmark_index
	last_left_bookmark_index = bookmark_index_pressed
	if(max_left_bookmark_index >= bookmark_index_pressed) {
		create_bookmarks(bookmark_index_pressed + 1, max_left_bookmark_index)
	}
	else {
		create_bookmarks(max_left_bookmark_index + 1, bookmark_index_pressed)
	}
	
	add_bookmark_bottom(x - bookmark_data[bookmark_index_pressed].x_pos)
	
	if(sprite_exists(spr_cover_front)) {
		sprite_delete(spr_cover_front)
		spr_cover_front = noone
	}
	if(sprite_exists(spr_cover_back)) {
		sprite_delete(spr_cover_back)
		spr_cover_back = noone
	}
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
			image_xscale : -bookmark_scale,
			image_yscale : bookmark_bottom_y_scale
		})
	}
}

/// @desc						Creates a scaled sprite the cover's front and back and places them in
///									spr_cover_front and spr_cover_back respectively
function create_cover_sprites() {
	var cover_surf = surface_create(sprite_width, sprite_height)
	surface_set_target(cover_surf)
	draw_clear_alpha(c_black, 0)
	
	draw_sprite_ext(sprite_index, 0, 0, 0, image_xscale, image_yscale,
									image_angle, image_blend, image_alpha)
	spr_cover_front = sprite_create_from_surface(cover_surf, 0, 0, 
							surface_get_width(cover_surf), surface_get_height(cover_surf),
							false, false, 0, 0)
	draw_clear_alpha(c_black, 0)
	
	draw_sprite_stretched(spr_cover, 0, 0, 0, sprite_width, sprite_height)
	spr_cover_back = sprite_create_from_surface(cover_surf, 0, 0, 
							surface_get_width(cover_surf), surface_get_height(cover_surf),
							false, false, 0, 0)
	surface_reset_target()
}