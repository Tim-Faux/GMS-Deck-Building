#macro PAGE_TURN_SPEED 0.03

flip_percent = 0
segment_num = 10

uniform_page_vertex_data = shader_get_uniform(shd_flip_page, "page_vertex_data")
uniform_page_flip_data = shader_get_uniform(shd_flip_page, "page_flip_data")
uniform_page_back = shader_get_sampler_index(shd_flip_page, "page_back")
vertex_buffer = create_vertex_buffer()

/// @desc						Creates a vertex buffer for the page with segment_num verticies
/// @returns {Id.VertexBuffer}	The vertex buffer for the flippable page
function create_vertex_buffer() {
	vertex_format_begin()
	vertex_format_add_position()
	vertex_format_add_texcoord()
	vertex_format_add_colour()
	var vertex_format = vertex_format_end()

	var buffer = vertex_create_buffer()
	vertex_begin(buffer, vertex_format)
	for(var segment_index = 0; segment_index <= segment_num; segment_index++) {
		vertex_position(buffer, segment_index, 0)
		vertex_texcoord(buffer, segment_index / segment_num, 0)
		vertex_colour(buffer, c_white, 1)
		
		vertex_position(buffer, segment_index, 1)
		vertex_texcoord(buffer, segment_index / segment_num, 1)
		vertex_colour(buffer, c_white, 1)
	}
	vertex_end(buffer)
	return buffer
}

/// @desc							Sets the page_dir and page_bend based on the flip_direction to create 
///										a smooth motion of the page flipping
/// @param {Real} cur_flip_percent	The percent of the current page's flip between 0 and 1
/// @returns {Array <Real, Real>}	The page direction and page bend at the given percent of the flip
function flip_book_page(cur_flip_percent) {
	if(flip_direction == page_flip_direction.none) {
		return	
	}
	
	var to_middle = clamp(cur_flip_percent, 0, 0.5) * 2
	var to_end = clamp(cur_flip_percent - 0.5, 0, 0.5) * 2

	var start_dir = 0
	var start_bend = 0

	var mid_dir = flip_direction == page_flip_direction.left ? 160 : 20
	var mid_bend = flip_direction == page_flip_direction.left ? -140 / segment_num : 140 / segment_num

	var end_dir = 180
	var end_bend = 0
	
	var page_dir = 0
	var page_bend = 0

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

	return [page_dir, page_bend]
}

/// @desc						Flips through all of the pages in pages_to_flip. NOTE: This should be run
///									every frame in the draw event
function flip_through_pages() {
	surface_set_target(application_surface)
	draw_clear_alpha(c_white,0);

	var _ztest = gpu_get_ztestenable()
	gpu_set_ztestenable(true)
	
	for(var page_index = 0; page_index < array_length(pages_to_flip); page_index++) {
		var current_page = pages_to_flip[page_index]
		draw_page_to_its_surface(current_page)

		shader_set(shd_flip_page)
		var page_flip_percent =  max(flip_percent - (page_index / 20), 0)
		var page_flip_data = flip_book_page(page_flip_percent)
		
		var segment_length = surface_get_width(current_page.surface) / segment_num
		shader_set_uniform_f(uniform_page_vertex_data, current_page.x_pos, current_page.y_pos, sprite_get_height(current_page.front_sprite), segment_length)
		
		var page_dir = page_flip_data[0] / 180 * pi
		var page_bend = current_page.bend_page ? page_flip_data[1] / 180 * pi : 0
		shader_set_uniform_f(uniform_page_flip_data, page_dir, page_bend)

		vertex_submit(vertex_buffer, pr_trianglestrip, surface_get_texture(current_page.surface))
		shader_reset()
		
		if(page_index == array_length(pages_to_flip) - 1 && page_flip_percent >= 1) {
			flip_ended()
		}
	}
	gpu_set_ztestenable(_ztest)

	surface_reset_target()
	draw_surface(application_surface, camera_get_view_x(view_camera[0]),camera_get_view_y(view_camera[0]))
}

/// @desc							Draws the given page onto it's surface, at the top left
///										of the surface
/// @param {Struct}  current_page	The page data used to draw this page
function draw_page_to_its_surface(current_page) {
	if(is_undefined(current_page.surface) ||
			!surface_exists(current_page.surface)) {
		current_page.surface = surface_create(sprite_get_width(current_page.front_sprite), sprite_get_height(current_page.front_sprite))
	}
	surface_set_target(current_page.surface)
	draw_clear_alpha(c_white,0);

	draw_sprite(current_page.front_sprite, 0, 0, 0)
	if(current_page.back_sprite != noone) {
		texture_set_stage(uniform_page_back, sprite_get_texture(current_page.back_sprite, 0))
	}
	surface_reset_target()
}


/// @desc						Handles the end of the page flip, deleting the page sprites and calling
///									on_page_flipped before destroying itself
function flip_ended() {			
	if(on_page_flipped != noone && is_method(on_page_flipped)) {
		method_call(on_page_flipped, on_page_flipped_args)	
	}
	instance_destroy()
}