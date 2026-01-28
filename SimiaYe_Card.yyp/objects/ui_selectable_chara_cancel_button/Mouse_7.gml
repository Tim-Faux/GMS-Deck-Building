if(is_top_layer(layer, mouse_x, mouse_y) && button_clicked) {
	button_clicked = false
	global.object_being_clicked = false
	
	obj_target_selection_handler.cancel_target_selection()
}