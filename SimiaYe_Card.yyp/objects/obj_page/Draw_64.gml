if(run_page_flip_sprite_creation) {
	var flipping_page_sprite = create_page_front_sprite(false)
	var flipping_page_sprite_back = create_page_back_sprite(false)
	run_page_flip_sprite_creation = false
	pages_to_flip = create_single_page_array(flipping_page_sprite, flipping_page_sprite_back)
	book_page_flipped(pages_to_flip)
}

draw_self()
if(book_is_open)
	draw_sprite_ext(sprite_index, 0, x, y, -image_xscale, image_yscale, image_angle, image_blend, image_alpha)
draw_elements_text(false)