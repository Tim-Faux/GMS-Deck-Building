// Inherit the parent event
event_inherited();

dropdown_items = ["640 X 360", "1280 X 720", "1600 X 900", "1920 X 1080", "2048 X 1152", "2560 X 1440", "3840 X 2160"]
old_resolution = $"{window_get_width()} X {window_get_height()}"
selected_value = old_resolution

/// @desc					Finds the default resolution of the screen and updates the window
function find_resolution() {
	var screen_width = display_get_width()
	
	if(screen_width < 1280)
		selected_value = dropdown_items[0]
	if(screen_width < 1600)
		selected_value = dropdown_items[1]
	if(screen_width < 1920)
		selected_value = dropdown_items[2]
	if(screen_width < 2048)
		selected_value = dropdown_items[3]
	if(screen_width < 2560)
		selected_value = dropdown_items[4]
	if(screen_width < 3840)
		selected_value = dropdown_items[5]
	if(screen_width >= 3840)
		selected_value = dropdown_items[6]
	else
		selected_value = dropdown_items[3]
	update_resolution()
}

/// @desc					Updates the game window to the resolution in selected_value
function update_resolution() {
	var new_resolution = string_split(selected_value, " X ")
	var new_width = real(string_digits(new_resolution[0]))
	var new_height = real(string_digits(new_resolution[1]))
	old_resolution = $"{window_get_width()} X {window_get_height()}"
	instance_create_layer(x, y, layer, ui_window_settings_updater, {
		screen_width : new_width,
		screen_height : new_height
	})
}

/// @desc					Resets the selected resolution to what it was before selecting a dropdown option
function revert_resolution_changes() {
	selected_value = old_resolution
}