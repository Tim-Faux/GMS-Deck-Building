#macro PAGE_TURN_SPEED 0.03

flip_percent = 0
page_dir = 0
page_bend = 0
segment_num = 10
segment_length = sprite_width / segment_num

surf = surface_create(sprite_width, sprite_height)
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
		sprite_delete(sprite_index)
		sprite_delete(spr_flipping_page_back)
			
		if(on_page_flipped != noone && is_method(on_page_flipped)) {
			method_call(on_page_flipped, on_page_flipped_args)	
		}
		instance_destroy()
	}
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
	shader_set_uniform_f(uniform_page_vertex_data, x, y, sprite_height, segment_length)
	shader_set_uniform_f(uniform_page_flip_data, page_dir / 180 * pi, page_bend / 180 * pi)

	vertex_submit(vertex_buffer, pr_trianglestrip, surface_get_texture(surf))
	shader_reset()
}