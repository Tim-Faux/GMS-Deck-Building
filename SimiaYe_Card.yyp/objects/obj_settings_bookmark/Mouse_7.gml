if(button_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
	if(on_bookmark_pressed != undefined && is_method(on_bookmark_pressed))
		method_call(on_bookmark_pressed, [obj_settings_chapter])
}