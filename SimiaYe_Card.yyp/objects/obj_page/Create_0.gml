#macro PAGE_TURN_SPEED 0.03

flip_percent = 0
page_dir = 0
page_bend = 0
segment_num = 10
segment_length = sprite_width / (segment_num - 1)

page_being_flipped = false
flip_direction = page_flip_direction.none

surf = surface_create(sprite_width, sprite_height)
vertex_buffer = create_vertex_buffer()

uniform_page_vertex_data = shader_get_uniform(shd_flip_page, "page_vertex_data")
uniform_page_flip_data = shader_get_uniform(shd_flip_page, "page_flip_data")
spr_flipping_page = undefined

current_page = 0
page_data = new book_menu_page_data(x, y, sprite_height, sprite_width)
page_elements_layer = layer_create(depth - 1, "page_elements_layer")

enum page_flip_direction {
	none,
	left,
	right,
}

/// @desc						Creates a vertex buffer for the page with segment_num - 1 verticies
/// @returns {Id.VertexBuffer}	The vertex buffer for the flippable page
function create_vertex_buffer() {
	vertex_format_begin()
	vertex_format_add_position()
	vertex_format_add_texcoord()
	vertex_format_add_colour()
	var vertex_format = vertex_format_end()

	var buffer = vertex_create_buffer()
	vertex_begin(buffer, vertex_format)
	for(var segment_index = 0; segment_index < segment_num; segment_index++) {
		vertex_position(buffer, segment_index, 0)
		vertex_texcoord(buffer, segment_index / (segment_num - 1), 0)
		vertex_colour(buffer, c_white, 1)
		
		vertex_position(buffer, segment_index, 1)
		vertex_texcoord(buffer, segment_index / (segment_num - 1), 1)
		vertex_colour(buffer, c_white, 1)
	}
	vertex_end(buffer)
	return buffer
}

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
	}
}

/// @desc						Sets the page_dir and page_bend based on the flip_direction to create
///									a smooth motion of the page flipping
function flip_book_page() {
	if(flip_direction == page_flip_direction.none) {
		return	
	}
	
	flip_percent = min(1, flip_percent + PAGE_TURN_SPEED)
	
	var to_middle = clamp(flip_percent, 0, 0.5) * 2
	var to_end = clamp(flip_percent - 0.5, 0, 0.5) * 2

	var start_dir = 0
	var start_bend = 0

	var mid_dir = flip_direction == page_flip_direction.left ? 160 : 20
	var mid_bend = flip_direction == page_flip_direction.left ? -180 / segment_num : 180 / segment_num

	var end_dir = 180
	var end_bend = 0

	if(flip_direction == page_flip_direction.left) {
		var end_of_flip_dir = lerp(mid_dir, end_dir, to_end)
		page_dir = lerp(start_dir, end_of_flip_dir, to_middle)
		page_bend = lerp(start_bend, lerp(mid_bend, end_bend, to_end), to_middle)
	}
	else {
		var end_of_flip_dir = lerp(mid_dir, start_dir, to_end)
		page_dir = lerp(end_dir, end_of_flip_dir, to_middle)
		page_bend = lerp(end_bend, lerp(mid_bend, start_bend, to_end), to_middle)
	}

	if(flip_percent >= 1) {
		page_being_flipped = false
		flip_percent = 0
		page_dir = start_dir
		page_bend = start_bend
		flip_direction = page_flip_direction.none
		sprite_delete(spr_flipping_page)
		spr_flipping_page = undefined
		current_page++
		create_page_objects()
	}
}

/// @desc						Draws a page that can be flipped like a book page using flip_book_page()
function draw_moveable_page() {
	if(is_undefined(surf) || !surface_exists(surf)) {
		surf = surface_create(sprite_width, sprite_height)
	}

	surface_set_target(surf)
	draw_clear_alpha(c_white, 0)
	
	if(page_being_flipped) {
		spr_flipping_page ??= create_page_flip_sprite()
		draw_sprite_ext(spr_flipping_page, 0, 0, 0, 1, 1,
									image_angle, image_blend, image_alpha)
	}
	else {
		draw_sprite_ext(sprite_index, 0, 0, 0, image_xscale, image_yscale,
									image_angle, image_blend, image_alpha)
		draw_elements_text()
	}
	surface_reset_target()
	shader_set(shd_flip_page)
	shader_set_uniform_f(uniform_page_vertex_data, x, y, sprite_height, segment_length)
	shader_set_uniform_f(uniform_page_flip_data, page_dir / 180 * pi, page_bend / 180 * pi)

	vertex_submit(vertex_buffer, pr_trianglestrip, surface_get_texture(surf))
	shader_reset()
}

/// @desc						Creates a sprite of the right side page with all of the elements
///									drawn on it
/// @returns {Asset.GMSprite}	The page sprite to be used for flipping the page
function create_page_flip_sprite() {
	var page_flip_surf = surface_create(sprite_width, sprite_height)
	surface_set_target(page_flip_surf)
	draw_clear_alpha(c_black, 0)
	
	draw_sprite_ext(sprite_index, 0, 0, 0, image_xscale, image_yscale,
									image_angle, image_blend, image_alpha)
	draw_elements_text()
									
	var related_layers = []
	for(var layer_to_check_depth = depth - 10; layer_to_check_depth <= depth; layer_to_check_depth++) {
		var layers_at_depth = layer_get_id_at_depth(layer_to_check_depth)
		if(layers_at_depth[0] != -1) {
			related_layers = array_concat(related_layers, layers_at_depth)
		}
	}
	for(var layer_index = 0; layer_index < array_length(related_layers); layer_index++) {
		var active_layer_elements = layer_get_all_elements(related_layers[layer_index])
		for(var element_index = 0; element_index < array_length(active_layer_elements); element_index++) {
			if (layer_get_element_type(active_layer_elements[element_index]) == layerelementtype_instance &&
					event_type == ev_draw)
		    {
				var layer_instance = layer_instance_get_instance(active_layer_elements[element_index])
				if(!object_is_ancestor(layer_instance.object_index, obj_page)) {
					layer_instance.x -= x
					layer_instance.y -= y
					if(event_number == ev_draw_normal) {
						with(layer_instance) {
							event_perform(ev_draw, ev_draw_normal)
						}
					}
			        else if (event_number == ev_gui) {
						with(layer_instance) {
							event_perform(ev_draw, ev_gui)
						}
					}
					instance_destroy(layer_instance)
				}
			}
		}
	}
	var spr_custom = sprite_create_from_surface(page_flip_surf, 0, 0, 
							surface_get_width(page_flip_surf), surface_get_height(page_flip_surf),
							false, false, 0, 0);
	surface_reset_target();
	return spr_custom
}

/// @desc						Draws the text for each page_data element
function draw_elements_text() {
	if(array_length(page_data.all_pages) >= current_page + 1) {
		draw_set_colour(c_black)
		var page_elements = page_data.all_pages[current_page].elements
		struct_foreach(page_elements, function(_name, _value) {
			draw_set_font(_value.font)
			draw_set_halign(_value.text_alignment)
			draw_text(_value.x_pos - x, _value.y_pos - y, _value.text)
		})	
		draw_set_halign(fa_left)
	}
}