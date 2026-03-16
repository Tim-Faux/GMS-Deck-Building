#macro PAGE_TURN_SPEED 0.03
#macro NUM_PAGES_FOR_CHAPTER_FLIP 20

flip_percent = 0
segment_num = 10
segment_length = sprite_width / segment_num

surf = surface_create(sprite_width, sprite_height)
chapter_flip_surf = -1
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

/// @desc						Handles the end of the page flip, deleting the page sprites and calling
///									on_page_flipped before destroying itself
function flip_ended() {
	if(!is_chapter_flip) {
		sprite_delete(sprite_index)
		sprite_delete(spr_flipping_page_back)
	}
			
	if(on_page_flipped != noone && is_method(on_page_flipped)) {
		method_call(on_page_flipped, on_page_flipped_args)	
	}
	instance_destroy()
}

/// @desc						Draws the page in a flipping animation. NOTE: This should be run
///									every frame in the draw event
function draw_moveable_page() {
	if(is_undefined(surf) || !surface_exists(surf)) {
		surf = surface_create(sprite_width, sprite_height)
	}

	surface_set_target(surf)
	draw_clear_alpha(c_white, 0)
	
	draw_sprite(sprite_index, 0, 0, 0)
	if(spr_flipping_page_back != noone)
		texture_set_stage(uniform_page_back, sprite_get_texture(spr_flipping_page_back, 0))

	surface_reset_target()
	
	shader_set(shd_flip_page)
	var page_flip_data = flip_book_page(flip_percent)
	shader_set_uniform_f(uniform_page_vertex_data, x, y, sprite_height, segment_length)
	shader_set_uniform_f(uniform_page_flip_data, page_flip_data[0] / 180 * pi, page_flip_data[1] / 180 * pi)

	vertex_submit(vertex_buffer, pr_trianglestrip, surface_get_texture(surf))
	shader_reset()
	
	if(flip_percent >= 1) {
		flip_ended()
	}
}

/// @desc						Flips multiple pages consecutively to give the appearence of a
///									new section of the book is opened. NOTE: This should be run
///									every frame in the draw event
function flip_to_chapter() {
	if(!surface_exists(chapter_flip_surf)){
	    chapter_flip_surf = surface_create(room_width, room_height)
	}
	surface_set_target(chapter_flip_surf)
	draw_clear_alpha(c_white,0);
	
	if(is_undefined(surf) || !surface_exists(surf)) {
		surf = surface_create(sprite_width, sprite_height)
	}

	var _ztest = gpu_get_ztestenable()
	gpu_set_ztestenable(true)
	for(var page_index = 0; page_index < NUM_PAGES_FOR_CHAPTER_FLIP; page_index++) {
		surface_set_target(surf)
		draw_clear_alpha(c_white, 0)

		draw_sprite_ext(sprite_index, 0, 0, 0, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
		if(spr_flipping_page_back == noone) {
			spr_flipping_page_back = sprite_create_from_surface(surf, 0, 0, sprite_width, sprite_height, false, false, 0, 0)
			texture_set_stage(uniform_page_back, sprite_get_texture(spr_flipping_page_back, 0))
		}
		else {
			texture_set_stage(uniform_page_back, sprite_get_texture(spr_flipping_page_back, 0))
		}
		surface_reset_target()

		shader_set(shd_flip_page)
		var page_flip_percent =  max(flip_percent - (page_index / 20), 0)
		var page_flip_data = flip_book_page(page_flip_percent)
		
		shader_set_uniform_f(uniform_page_vertex_data, x, y, sprite_height, segment_length)
		shader_set_uniform_f(uniform_page_flip_data, page_flip_data[0] / 180 * pi, page_flip_data[1] / 180 * pi)

		vertex_submit(vertex_buffer, pr_trianglestrip, surface_get_texture(surf))
		shader_reset()
		
		if(page_index == NUM_PAGES_FOR_CHAPTER_FLIP - 1 && page_flip_percent >= 1) {
			flip_ended()
		}
	}
	gpu_set_ztestenable(_ztest)
	surface_reset_target()
	draw_surface(chapter_flip_surf, camera_get_view_x(view_camera[0]),camera_get_view_y(view_camera[0]))
}