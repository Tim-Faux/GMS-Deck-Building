if(!global.object_being_clicked && mouse_check_button_pressed(mb_left) && is_top_layer(layer, mouse_x, mouse_y)) {
	global.object_being_clicked	= true
	card_clicked = true
}