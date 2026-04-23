if(!variable_global_exists("object_being_clicked")) {
	global.object_being_clicked = false
}
button_clicked = false

function handle_mouse_enter() {
	if(is_top_layer(layer, mouse_x, mouse_y) && (!global.object_being_clicked || button_clicked)) {
		image_alpha = 0.6
	}
}