if(is_top_layer(layer) && !global.object_being_clicked) {
	dropdown_clicked = true
	global.object_being_clicked = true
	dropdown_release_num = 0
	
	show_drop_down_options()
}