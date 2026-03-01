#macro PAGE_TURN_SPEED 0.03

var cover_nine_slice = sprite_get_nineslice(spr_cover)
page_x_pos = x
page_y_pos = y + cover_nine_slice.top

//Not subtracting the left nineslice because we want the pages to meet exactly in the middle
page_width = sprite_width  - cover_nine_slice.right
page_height = sprite_height - cover_nine_slice.bottom - cover_nine_slice.top

flip_percent = 0
page_dir = 0
page_bend = 0
segment_num = 10

segment_length = page_width / (segment_num - 1)

page_being_flipped = false
flip_direction = page_flip_direction.none

surf = undefined
vertex_buffer = create_vertex_buffer()

page_x_scale = page_width / sprite_get_width(sprite_index)
page_y_scale = page_height / sprite_get_height(sprite_index)

uniform_page_vertex_data = shader_get_uniform(shd_flip_page, "page_vertex_data")
uniform_page_flip_data = shader_get_uniform(shd_flip_page, "page_flip_data")

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
	}
}

/// @desc						Draws a spr_cover and a flipped spr_cover, each the size of this object
///									with x being the center between them. Then draws sprite_index over
///									each of them
function draw_cover() {
	draw_sprite_ext(spr_cover, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
	draw_sprite_ext(sprite_index, 0, page_x_pos, page_y_pos, page_x_scale, page_y_scale,
							image_angle, image_blend, image_alpha)
						
	draw_sprite_ext(spr_cover, 0, x, y, -image_xscale, image_yscale, image_angle, image_blend, image_alpha)
	draw_sprite_ext(sprite_index, 0, page_x_pos, page_y_pos, -page_x_scale, page_y_scale, 
							image_angle, image_blend, image_alpha)	
}

/// @desc						Draws a page that can be flipped like a book page using flip_book_page()
function draw_moveable_page() {
	if(is_undefined(surf) || !surface_exists(surf)) {
		surf = surface_create(page_width, page_height)
	}

	surface_set_target(surf)
	draw_clear_alpha(c_white, 0)
	draw_sprite_ext(sprite_index, 0, 0, 0, page_x_scale, page_y_scale,
									image_angle, image_blend, image_alpha)

	surface_reset_target()
	shader_set(shd_flip_page)
	shader_set_uniform_f(uniform_page_vertex_data, page_x_pos, page_y_pos, page_height, segment_length)
	shader_set_uniform_f(uniform_page_flip_data, page_dir / 180 * pi, page_bend / 180 * pi)

	vertex_submit(vertex_buffer, pr_trianglestrip, surface_get_texture(surf))
	shader_reset()
}