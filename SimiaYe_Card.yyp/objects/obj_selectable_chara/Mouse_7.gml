if(chara_clicked && is_top_layer(layer)) {
	chara_clicked = false
	global.object_being_clicked = false
	y = ystart
	is_selected = true
	obj_target_selection_handler.target_selected(chara_instance)
}