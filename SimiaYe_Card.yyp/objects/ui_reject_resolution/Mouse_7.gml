if(button_clicked && is_top_layer(layer)) {
	button_clicked = false
	global.object_being_clicked = false
	ui_window_settings_updater.revert_resolution_changes()
	find_and_delete_related_layers(layer)
}