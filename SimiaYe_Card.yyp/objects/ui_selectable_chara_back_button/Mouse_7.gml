if(button_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
	button_clicked = false
	global.object_being_clicked = false
	
	layer_destroy_instances(layer)
	if(is_method(back_return_fuction) && back_return_fuction != undefined) {
		method_call(back_return_fuction, [])
	}
}