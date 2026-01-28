if(!global.object_being_clicked && mouse_check_button_pressed(mb_left) && is_top_layer(layer)) {
	scroll_clicked = true
	global.object_being_clicked = true
	
	if(mouse_y < amount_page_scrolled ||  mouse_y > amount_page_scrolled + scroll_thumb.sprite_height) {
		pos_thumb_clicked = scroll_thumb.sprite_height / 2
	}
	else {
		pos_thumb_clicked = mouse_y - scroll_thumb.y
	}
}