#macro YOUR_RESOLUTION_HAS_CHANGED "Your resolution has changed. Please accept the changes or\nthey will be reverted in "
#macro ACCEPT_RESOLUTION_TEXT_PADDING 200
#macro RESOLUTION_ACCEPTANCE_BUTTON_PADDING 20

time_to_automatic_revert = 10
create_accept_and_revert_buttons()
alarm_set(0, 60)

/// @desc								Creates and positions the buttons to accept/reject the new
///											window size
function create_accept_and_revert_buttons() {
	var accept_button_x = (display_get_gui_width() / 2) - (sprite_get_width(object_get_sprite(ui_accept_resolution)) / 2) -
								RESOLUTION_ACCEPTANCE_BUTTON_PADDING
	var accept_button_y =  ((display_get_gui_height() - string_height(YOUR_RESOLUTION_HAS_CHANGED)) / 2) +
								string_height(YOUR_RESOLUTION_HAS_CHANGED)
	var reject_button_x = (display_get_gui_width() / 2) + (sprite_get_width(object_get_sprite(ui_reject_resolution)) / 2) +
								RESOLUTION_ACCEPTANCE_BUTTON_PADDING
	var reject_button_y = accept_button_y
	
	var button_layers = layer_create(depth - 1)
	instance_create_layer(accept_button_x, accept_button_y, button_layers, ui_accept_resolution)
	instance_create_layer(reject_button_x, reject_button_y, button_layers, ui_reject_resolution)
}

/// @desc								Draws a rectangle over the whole camera to dim the game
///											NOTE: this must be called in the Draw event or it won't
///											work correctly
function draw_prompt_background() {
	draw_set_colour(c_black)
	draw_set_alpha(BACKGROUND_ALPHA)
	var screen_width = display_get_gui_width()
	var screen_height = display_get_gui_height()
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)
}

/// @desc								Draws the resolution change confirmation text
///											NOTE: this must be called in the Draw event or it won't
///											work correctly
function draw_prompt_text() {
	var y_pos = (display_get_gui_height() / 2) - string_height(YOUR_RESOLUTION_HAS_CHANGED)
	var text_to_display = YOUR_RESOLUTION_HAS_CHANGED + string(time_to_automatic_revert) + " seconds"
	setup_prompt_font()
	
	var text_size_scale = 1;
	if ((display_get_gui_width() - (ACCEPT_RESOLUTION_TEXT_PADDING * 2)) > 0) {
		var text_width = string_width(YOUR_RESOLUTION_HAS_CHANGED)
	    text_size_scale = (display_get_gui_width() - (ACCEPT_RESOLUTION_TEXT_PADDING * 2)) / text_width;
	}
	
	draw_text_transformed(ACCEPT_RESOLUTION_TEXT_PADDING, y_pos, text_to_display, text_size_scale, text_size_scale, 0)
}

/// @desc								Sets the parameters defining how the propmt text is displayed
function setup_prompt_font() {
	draw_set_halign(fa_left)
	draw_set_colour(font_color)
	font_enable_effects(font, true, {
		dropShadowEnable: true,
		dropShadowSoftness: 20,
		dropShadowColour: c_black
	})
	draw_set_font(font)
}

/// @desc								Handles what happens when Alarm 0 finishes. This will either
///											decrement time_to_automatic_revert and reset the alarm or
///											automatically handle reverting the resolution changes.
function alarm_0_triggered() {
	if(time_to_automatic_revert <= 0) {
		ui_window_settings_updater.revert_resolution_changes()
		find_and_delete_related_layers(layer)
	}
	else {
		time_to_automatic_revert--
		alarm_set(0, 60)
	}
}