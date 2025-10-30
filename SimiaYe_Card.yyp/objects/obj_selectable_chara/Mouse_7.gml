if(chara_clicked && is_top_layer(layer)) {
	chara_clicked = false
	global.object_being_clicked = false
	obj_target_selection_handler.target_selected(chara_instance)
}