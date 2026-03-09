if(button_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
	if(on_button_pressed != undefined && is_method(on_button_pressed))
		method_call(on_button_pressed, on_button_pressed_args)
}