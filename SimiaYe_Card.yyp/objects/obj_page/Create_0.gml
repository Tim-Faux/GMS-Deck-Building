current_page = 0
run_page_flip_sprite_creation = false
flip_direction = page_flip_direction.none

page_data = new book_menu_page_data(x, y, sprite_height, sprite_width)
page_elements_layer = layer_create(depth - 1, "page_elements_layer")
flip_page_layer = layer_create(depth - 5, "flip_page_layer")

/// @desc						Creates the current page's interactable elements
function create_page_objects() {
	if(array_length(page_data.all_pages) >= current_page + 1) {
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
		
		create_page_flip_button()
	}
}

/// @desc						Creates the next and previous page buttons based on number of pages
///									avaliable in the button's direction
function create_page_flip_button() {
	var cover_nineslice = sprite_get_nineslice(object_get_sprite(obj_book_menu))
	var next_page_button_width = sprite_get_width(object_get_sprite(ui_next_book_page_button))
	var next_page_button_scale = cover_nineslice.right / next_page_button_width
	if(array_length(page_data.all_pages) > current_page + 1) {
		instance_create_layer(x + sprite_width + next_page_button_width, y + (sprite_height / 2), page_elements_layer, ui_next_book_page_button, {
			on_button_pressed : method(self, book_page_flipped),
			on_button_pressed_args : [page_flip_direction.left],
			image_xscale : next_page_button_scale,
			image_yscale : next_page_button_scale
		})
	}
	if(current_page > 0) {
		instance_create_layer(x - sprite_width - next_page_button_width, y + (sprite_height / 2), page_elements_layer, ui_next_book_page_button, {
			on_button_pressed : method(self, book_page_flipped),
			on_button_pressed_args : [page_flip_direction.right],
			image_xscale : -next_page_button_scale,
			image_yscale : next_page_button_scale
		})
	}
}

/// @desc											Call back function for when a ui_next_book_page_button
///														is pressed. This will set up and create
///														the obj_flipping_page
/// @param {Id.Instance} flipping_page_sprite		The sprite to be used for obj_flipping_page's
///														front. If none is provided it will be created
///														during the next Draw GUI event.
/// @param {Id.Instance} flipping_page_sprite_back	The sprite to be used for obj_flipping_page's
///														back
function book_page_flipped(page_flip_dir, flipping_page_sprite = noone, flipping_page_sprite_back = noone) {
	flip_direction = page_flip_dir
	
	if(flipping_page_sprite == noone) {
		run_page_flip_sprite_creation = true
	}
	else {
		run_page_flip_sprite_creation = false
		if(page_flip_dir == page_flip_direction.left) {
			layer_destroy_instances(page_elements_layer)
			current_page = min(array_length(page_data.all_pages) - 1, current_page + 1)
			create_page_objects()
			
			instance_create_layer(x, y, flip_page_layer, obj_flipping_page, {
				flip_direction : page_flip_dir,
				sprite_index : flipping_page_sprite,
				spr_flipping_page_back : flipping_page_sprite_back
			})
		}
		else {
			instance_create_layer(x, y, flip_page_layer, obj_flipping_page, {
				flip_direction : page_flip_dir,
				sprite_index : flipping_page_sprite,
				spr_flipping_page_back : flipping_page_sprite_back,
				on_page_flipped : method(self, page_flip_finished),
				on_page_flipped_args : []
			})
		}
	}
}

/// @desc						Cleans up the previously shown page and creates this page's elements
///									when flipping the page to the right
function page_flip_finished() {
	layer_destroy_instances(page_elements_layer)
	current_page = max(0, current_page - 1)
	create_page_objects()
}

/// @desc						Creates a sprite of the right side page with all of it's elements
///									drawn on it
function create_page_flip_sprite() {
	var page_flip_surf = surface_create(sprite_width, sprite_height)
	surface_set_target(page_flip_surf)
	draw_clear_alpha(c_black, 0)
	
	draw_sprite_stretched(sprite_index, 0, 0, 0, sprite_width, sprite_height)
	var page_num = current_page
	if(flip_direction == page_flip_direction.right)
		page_num--
	draw_elements_text(true, page_num)
	
	
	if(array_length(page_data.all_pages) - 1 > page_num) {
		var page_elements = page_data.all_pages[page_num].elements
		
		struct_foreach(page_elements, function(_name, _value) {
			if(struct_exists(_value, "element")) {
				var temp_instance = instance_create_layer(_value.x_pos + column_width - x, _value.y_pos - y, page_elements_layer, _value.element)
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
	surface_reset_target()
	
	var spr_custom = sprite_create_from_surface(page_flip_surf, 0, 0, 
							surface_get_width(page_flip_surf), surface_get_height(page_flip_surf),
							false, false, 0, 0)
	surface_free(page_flip_surf)
	return spr_custom
}

/// @desc						Creates a scaled sprite of a blank page for the page's back
/// @returns {Asset.GMSprite}	The page sprite to be used for back of a page
function create_page_back_sprite() {
	var page_back_surf = surface_create(sprite_width, sprite_height)
	surface_set_target(page_back_surf)
	draw_clear_alpha(c_black, 0)
	
	draw_sprite_ext(sprite_index, 0, 0, 0, image_xscale, image_yscale,
									image_angle, image_blend, image_alpha)
	var spr_custom = sprite_create_from_surface(page_back_surf, 0, 0, 
							surface_get_width(page_back_surf), surface_get_height(page_back_surf),
							false, false, 0, 0)
	surface_reset_target()
	return spr_custom
}

/// @desc								Draws the text for each page_data element for the given page
/// @param {bool} adjust_for_surface	Flag to determine if the text position should be based on 0, 0
///											or based on the page's position
/// @param {Real} page_num				Optional number to chose a page to draw the text for
function draw_elements_text(adjust_for_surface, page_num = current_page) {
	if(array_length(page_data.all_pages) - 1 > page_num) {
		draw_set_colour(c_black)
		var page_elements = page_data.all_pages[page_num].elements
		var page_element_names = variable_struct_get_names(page_elements)
		for(var name_index = 0; name_index < array_length(page_element_names); name_index++) {
			var page_element = struct_get(page_elements, page_element_names[name_index])
			draw_set_font(page_element.font)
			draw_set_halign(page_element.text_alignment)
			if(adjust_for_surface) {
				draw_text(page_element.x_pos - x, page_element.y_pos - y, page_element.text)
			}
			else {
				draw_text(page_element.x_pos, page_element.y_pos, page_element.text)
			}
		}	
		draw_set_halign(fa_left)
	}
}