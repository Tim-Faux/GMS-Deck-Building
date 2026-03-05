if(mouse_check_button_released(mb_left)) {
	page_being_flipped = true
}

if (page_being_flipped) {
	if(flip_direction == page_flip_direction.none && mouse_x < x) {
		flip_direction = page_flip_direction.right
	}
	else if(flip_direction == page_flip_direction.none) {
		flip_direction = page_flip_direction.left
	}
	flip_book_page()
}