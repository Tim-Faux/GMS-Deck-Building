#macro NUM_PAGES_FOR_CHAPTER_FLIP 20

current_page = -1
run_page_flip_sprite_creation = false
flip_direction = page_flip_direction.left

page_data = new book_menu_page_data(x, y, sprite_height, sprite_width)
page_elements_layer = layer_create(depth - 1, "page_elements_layer")
flip_page_layer = layer_create(depth - 2, "flip_page_layer")

bookmark_height = array_length(bookmarks_to_flip) > 0 ? 
						(sprite_get_height(bookmarks_to_flip[0].sprite) * bookmark_scale) :
						0
						
page_surf = surface_create(sprite_width, sprite_height + bookmark_height)
var page_front_sprites = create_page_front_sprite(true)
var page_back_sprites = create_page_back_sprite(true)
pages_to_flip = create_chapter_pages_array(page_front_sprites, page_back_sprites)
book_page_flipped(pages_to_flip)

/// @desc						Creates the current page's interactable elements
function create_page_objects() {
	if(current_page > -1 && array_length(page_data.all_pages) >= current_page + 1) {
		if(layer_exists("page_elements_layer")) {
			page_elements_layer = layer_get_id("page_elements_layer")
		}
		else {
			page_elements_layer = layer_create(depth - 1, "page_elements_layer")
		}
	
		column_width = (sprite_width / 2) - (2 * BOOK_PAGE_ELEMENT_PADDING)
		var page_elements = page_data.all_pages[current_page].elements
		struct_foreach(page_elements, function(_name, _value) {
			if(struct_exists(_value, "element")) {
				instance_create_layer(_value.x_pos + column_width, _value.y_pos, page_elements_layer, _value.element)
			}
		})
	}
}

/// @desc						Creates the next and previous page buttons based on number of pages
///									avaliable in the button's direction
function create_page_flip_button() {
	if(layer_exists("page_elements_layer")) {
		page_elements_layer = layer_get_id("page_elements_layer")
	}
	else {
		page_elements_layer = layer_create(depth - 1, "page_elements_layer")
	}
	
	var cover_nineslice = sprite_get_nineslice(spr_cover)
	var next_page_button_width = sprite_get_width(object_get_sprite(ui_next_book_page_button))
	var next_page_button_scale = cover_nineslice.right / next_page_button_width
	if(array_length(page_data.all_pages) > current_page + 1) {
		instance_create_layer(x + sprite_width + next_page_button_width, y + (sprite_height / 2), page_elements_layer, ui_next_book_page_button, {
			on_button_pressed : method(self, flip_page_button_pressed),
			on_button_pressed_args : [page_flip_direction.left],
			image_xscale : next_page_button_scale,
			image_yscale : next_page_button_scale
		})
	}
	if(current_page > 0) {
		instance_create_layer(x - sprite_width - next_page_button_width, y + (sprite_height / 2), page_elements_layer, ui_next_book_page_button, {
			on_button_pressed : method(self, flip_page_button_pressed),
			on_button_pressed_args : [page_flip_direction.right],
			image_xscale : -next_page_button_scale,
			image_yscale : next_page_button_scale
		})
	}
}

/// @desc											Call back function for ui_next_book_page_button. 
///														Sets up for the page to be turned in the given
///														direction on the next draw event
/// @param {page_flip_direction} page_flip_dir		The direction the page will be flipped to
function flip_page_button_pressed(page_flip_dir) {
	run_page_flip_sprite_creation = true
	flip_direction = page_flip_dir
}

/// @desc												Creates an array of structs to represent the
///															different pages that are flipped when on
///															a chapter change
/// @param {Array<Asset.GMSprite>} page_front_sprites	All the sprites used for the fronts of the pages
/// @param {Array<Asset.GMSprite>} page_back_sprites	All the sprite used for the backs of the pages
/// @returns {Array <Struct>}							The positional and sprite data of all the pages
///															to be used when flipping the pages
function create_chapter_pages_array(page_front_sprites = [spr_page], page_back_sprites = [spr_page]) {
	var chapter_pages_array = array_create(NUM_PAGES_FOR_CHAPTER_FLIP + 1, -1)
	var page_sprite_index = 0
	for(var page_index = 0; page_index < array_length(chapter_pages_array) - 1; page_index++) {
		if(!book_is_open && page_index == 0) {
			chapter_pages_array[page_index] = pages_array
		}
		else {
			if(array_length(page_front_sprites) > 1) {
				var total_num_pages = NUM_PAGES_FOR_CHAPTER_FLIP - 1
				var num_bookmark_pages = array_length(page_back_sprites) - 2
				var blank_to_bookmark_page_ratio = total_num_pages / num_bookmark_pages
				var num_pages_until_bookmark_page = (max(blank_to_bookmark_page_ratio, 1))
				
				if((page_index + 1) % num_pages_until_bookmark_page < 1 &&
						page_sprite_index < array_length(page_front_sprites) - 2 && 
						page_sprite_index < array_length(page_back_sprites) - 2) {
					chapter_pages_array[page_index] = {	
												front_sprite : page_front_sprites[page_sprite_index],
												back_sprite : page_back_sprites[page_sprite_index],
												x_pos : x,
												y_pos : y - bookmark_height,
												bend_page : true,
												surface : page_surf }
					page_sprite_index++
				}
			}
			if(chapter_pages_array[page_index] == -1) {
				chapter_pages_array[page_index] = {	
												front_sprite : array_last(page_front_sprites),
												back_sprite : array_last(page_back_sprites),
												x_pos : x,
												y_pos : y - bookmark_height,
												bend_page : true,
												surface : page_surf }
			}
		}
	}
	
	chapter_pages_array[NUM_PAGES_FOR_CHAPTER_FLIP] = {	
												front_sprite : page_front_sprites[array_length(page_front_sprites) - 2],
												back_sprite : page_back_sprites[array_length(page_back_sprites) - 2],
												x_pos : x,
												y_pos : y - bookmark_height,
												bend_page : true,
												surface : page_surf }
	return chapter_pages_array
}

/// @desc												Creates an array with a single structs to represent
///															the one page being flipped
/// @param {Array<Asset.GMSprite>} page_front_sprite	The sprites used for the front of the page
/// @param {Array<Asset.GMSprite>} page_back_sprite		The sprites used for the back of the page
function create_single_page_array(page_front_sprite = [spr_page], page_back_sprite = [spr_page]) {
	return [{ front_sprite : page_front_sprite[0],
				back_sprite : page_back_sprite[0],
				x_pos : x,
				y_pos : y - bookmark_height,
				bend_page : true,
				surface : page_surf }]
}

/// @desc									Sets up an obj_flipping_page to animate the given pages
///												as flipping in the flip_direction
/// @param {Array<Struct>} page_array		The array containing the data needed to draw each page
function book_page_flipped(page_array) {
	if(flip_direction == page_flip_direction.left) {
		current_page = clamp(current_page + 1, 0, array_length(page_data.all_pages) - 1)
		layer_destroy_instances(page_elements_layer)
		create_page_objects()
		instance_create_layer(page_array[0].x_pos, page_array[0].y_pos, flip_page_layer, obj_flipping_page, {
			flip_direction,
			pages_to_flip : page_array,
			on_page_flipped : method(self, page_flip_finished),
			on_page_flipped_args : []
		})
			
	}
	else {
		if(current_page > 1 && instance_number(obj_bookmark_bottom) > 0) {
			obj_bookmark_bottom.visible = false
		}
		else if(current_page <= 1 && instance_number(obj_bookmark_bottom) > 0) {
			obj_bookmark_bottom.visible = true
		}
		instance_create_layer(x, y, flip_page_layer, obj_flipping_page, {
			flip_direction,
			pages_to_flip : page_array,
			on_page_flipped : method(self, page_flipped_right),
			on_page_flipped_args : []
		})
	}
}

/// @desc						Cleans up the previously shown page and creates this page's elements
///									when flipping the page to the right
function page_flipped_right() {
	layer_destroy_instances(page_elements_layer)
	current_page = max(0, current_page - 1)
	create_page_objects()
	page_flip_finished()
}

/// @desc						Call back function for obj_flipping_page. Handles the actions needed
///									after the page flip animation is complete
function page_flip_finished() {
	if(!book_is_open) {
		book_is_open = true
	}
	
	if(current_page > 0 && instance_number(obj_bookmark_bottom) > 0) {
		obj_bookmark_bottom.visible = false
	}
	else if(current_page == 0 && instance_number(obj_bookmark_bottom) > 0) {
		obj_bookmark_bottom.visible = true
	}
	
	create_page_flip_button()
	delete_pages_sprites()
	
	if(on_cover_opened != noone && is_method(on_cover_opened)) {
		method_call(on_cover_opened, on_cover_opened_args)	
	}
}

/// @desc						Deletes all the front and back sprites of pages_to_flip's pages
function delete_pages_sprites() {
	for(var page_index = 0; page_index < array_length(pages_to_flip); page_index++) {
		var page_sprite_front = pages_to_flip[page_index].front_sprite
		var page_sprite_back = pages_to_flip[page_index].back_sprite
		if(sprite_exists(page_sprite_front)) {
			sprite_delete(page_sprite_front)
		}
		if(sprite_exists(page_sprite_back)) {
			sprite_delete(page_sprite_back)
		}
	}	
}

/// @desc								Creates a sprite of the right side page with all of it's elements
///											drawn on it
/// @param {bool} is_chapter_flip		Flag to determine if the bookmark should be added to the sprite
/// @returns {Array<Asset.GMSprite>}	An array of the page's front sprites
function create_page_front_sprite(is_chapter_flip) {
	surface_set_target(page_surf)
	var page_sprites = array_create(array_length(bookmarks_to_flip) + 1)
	for(var bookmark_index = 0; bookmark_index < array_length(bookmarks_to_flip) + 1; bookmark_index++) {
		draw_clear_alpha(c_black, 0)
	
		if(bookmark_index < array_length(bookmarks_to_flip) && is_chapter_flip) {
			draw_sprite_ext(bookmarks_to_flip[bookmark_index].sprite, 0, bookmarks_to_flip[bookmark_index].x_pos - x, 0, bookmark_scale, 
												bookmark_scale, image_angle, image_blend, image_alpha)
		}
		draw_sprite_ext(sprite_index, 0, 0, bookmark_height, image_xscale, image_yscale,
										image_angle, image_blend, image_alpha)
		if(current_page > -1) {
			var page_num = current_page
			if(flip_direction == page_flip_direction.right)
				page_num--
			draw_elements_text(true, page_num)
	
	
			if(array_length(page_data.all_pages) - 1 > page_num) {
				var page_elements = page_data.all_pages[page_num].elements
		
				struct_foreach(page_elements, function(_name, _value) {
					if(struct_exists(_value, "element")) {
						var temp_instance = instance_create_layer(_value.x_pos + column_width - x, _value.y_pos - y + bookmark_height, page_elements_layer, _value.element)
						if(event_number == ev_draw_normal) {
							with(temp_instance) {
								event_perform(ev_draw, ev_draw_normal)
							}
						}
						else if (event_number == ev_gui) {
							with(temp_instance) {
								event_perform(ev_draw, ev_gui)
							}
						}
						instance_destroy(temp_instance)
					}
				})	
			}
		}
		var spr_custom = sprite_create_from_surface(page_surf, 0, 0, 
								surface_get_width(page_surf), surface_get_height(page_surf),
								false, false, 0, 0)
		page_sprites[bookmark_index] = spr_custom
	}
	surface_reset_target()
	return page_sprites
}

/// @desc								Creates a scaled sprite of a blank page for the page's back
/// @param {bool} is_chapter_flip		Flag to determine if the bookmark should be added to the sprite
/// @returns {Array<Asset.GMSprite>}	An array of the page's back sprites
function create_page_back_sprite(is_chapter_flip) {
	surface_set_target(page_surf)
	var page_sprites = array_create(array_length(bookmarks_to_flip) + 1)
	for(var bookmark_index = 0; bookmark_index < array_length(bookmarks_to_flip) + 1; bookmark_index++) {
		draw_clear_alpha(c_black, 0)
		
		if(bookmark_index < array_length(bookmarks_to_flip) && is_chapter_flip) {
			draw_sprite_ext(bookmarks_to_flip[bookmark_index].sprite, 0, bookmarks_to_flip[bookmark_index].x_pos - x, 0, bookmark_scale, 
												bookmark_scale, image_angle, image_blend, image_alpha)
		}
		
		draw_sprite_ext(sprite_index, 0, 0, bookmark_height, image_xscale, image_yscale,
										image_angle, image_blend, image_alpha)
										
		if(bookmark_index < array_length(bookmarks_to_flip) && is_chapter_flip) {
			var bookmark_bottom_y_scale = 0.5 * sprite_height / sprite_get_height(object_get_sprite(obj_bookmark_bottom))
			draw_sprite_ext(spr_bookmark_bottom, 0, bookmarks_to_flip[bookmark_index].x_pos - x, bookmark_height, bookmark_scale, 
												bookmark_bottom_y_scale, image_angle, image_blend, image_alpha)
		}
										
		var spr_custom = sprite_create_from_surface(page_surf, 0, 0, 
								surface_get_width(page_surf), surface_get_height(page_surf),
								false, false, 0, 0)
		page_sprites[bookmark_index] = spr_custom
	}
	surface_reset_target()
	return page_sprites
}

/// @desc								Draws the text for each page_data element for the given page
/// @param {bool} adjust_for_surface	Flag to determine if the text position should be based on 0, 0
///											or based on the page's position
/// @param {Real} page_num				Optional number to chose a page to draw the text for
function draw_elements_text(adjust_for_surface, page_num = current_page) {
	if(page_num > -1 && array_length(page_data.all_pages) - 1 > page_num) {
		draw_set_colour(c_black)
		var page_elements = page_data.all_pages[page_num].elements
		var page_element_names = variable_struct_get_names(page_elements)
		for(var name_index = 0; name_index < array_length(page_element_names); name_index++) {
			var page_element = struct_get(page_elements, page_element_names[name_index])
			draw_set_font(page_element.font)
			draw_set_halign(page_element.text_alignment)
			if(adjust_for_surface) {
				draw_text(page_element.x_pos - x, page_element.y_pos - y + bookmark_height, page_element.text)
			}
			else {
				draw_text(page_element.x_pos, page_element.y_pos, page_element.text)
			}
		}	
		draw_set_halign(fa_left)
	}
}