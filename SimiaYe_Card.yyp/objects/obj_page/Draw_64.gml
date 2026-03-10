if(run_page_flip_sprite_creation) {
	var flipping_page_sprite = create_page_flip_sprite()
	var flipping_page_sprite_back = create_page_back_sprite()
	book_page_flipped(flip_direction, flipping_page_sprite, flipping_page_sprite_back)
}

draw_self()
draw_elements_text(false)