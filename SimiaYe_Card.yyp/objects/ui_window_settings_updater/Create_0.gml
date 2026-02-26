step_number = 0
old_window_width = window_get_width()
old_window_height = window_get_height()

/// @desc					Resets the window size to what it was before updating the option
function revert_resolution_changes() {
	window_set_size(old_window_width, old_window_height);
	ui_resolution_dropdown.revert_resolution_changes()
	window_center()
	instance_destroy()
}

/// @desc					Handles accepting resolution change by destroying this object
function accept_resolution_changes() {
	instance_destroy()
}