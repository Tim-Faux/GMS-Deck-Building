if(chara_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
	chara_clicked = false
	global.object_being_clicked = false
	is_selected = !is_selected
	if(is_selected) 
		obj_target_selection_handler.target_selected(chara_instance)
	else 
		obj_target_selection_handler.target_deselected(chara_instance)
}