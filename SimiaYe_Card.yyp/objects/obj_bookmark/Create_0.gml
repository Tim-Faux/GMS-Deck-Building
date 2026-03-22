if(!variable_global_exists("object_being_clicked")) {
	global.object_being_clicked = false
}
bookmark_clicked = false
is_active_bookmark = false

/// @desc							Handles the mouse hovering over the bookmark
function handle_mouse_enter() {
	if(!is_active_bookmark && (!global.object_being_clicked || bookmark_clicked) && is_top_layer(layer, mouse_x, mouse_y)) {
		image_alpha = 0.6
	}
}

/// @desc							Handels the bookmark being pressed and calling on_bookmark_pressed
function bookmark_pressed() {
	if(bookmark_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
		image_alpha = 1
		obj_bookmark.is_active_bookmark = false
		is_active_bookmark = true
		if(on_bookmark_pressed != undefined && is_method(on_bookmark_pressed))
			method_call(on_bookmark_pressed, [bookmark_chapter, bookmark_index])
	}	
}