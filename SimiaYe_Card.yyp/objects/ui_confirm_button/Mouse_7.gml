if(button_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
	if(on_confirm_function != undefined && is_method(on_confirm_function))
			method_call(on_confirm_function, on_confirm_function_args)
	button_clicked = false
	global.object_being_clicked = false
	find_and_delete_related_layers(layer)
}