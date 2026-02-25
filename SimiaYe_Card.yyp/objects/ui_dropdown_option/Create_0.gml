#macro DROPDOWN_OPTION_TEXT_PADDING 10

/// @desc					Draws the text for the dropdown option
function draw_option_text() {
	var text_height = string_height(option_text);
	var text_width = string_width(option_text);
	var text_y_size_scale = 1;
	var text_x_size_scale = 1;
	if ((sprite_height - (DROPDOWN_OPTION_TEXT_PADDING * 2)) > 0 && text_height > 
			(sprite_height - (DROPDOWN_OPTION_TEXT_PADDING * 2))) {
	    text_y_size_scale = (sprite_height - (DROPDOWN_OPTION_TEXT_PADDING * 2)) / text_height;
	}
	if ((sprite_width - (DROPDOWN_OPTION_TEXT_PADDING * 2)) > 0 && text_width > 
			(sprite_width - (DROPDOWN_OPTION_TEXT_PADDING * 2))) {
	    text_x_size_scale = (sprite_width - (DROPDOWN_OPTION_TEXT_PADDING * 2)) / text_width;
	}
	if(text_y_size_scale < text_x_size_scale)
		draw_text_transformed(x + DROPDOWN_OPTION_TEXT_PADDING, y + DROPDOWN_OPTION_TEXT_PADDING,
								option_text, text_y_size_scale, text_y_size_scale, 0);
	else
		draw_text_transformed(x + DROPDOWN_OPTION_TEXT_PADDING, y + DROPDOWN_OPTION_TEXT_PADDING,
								option_text, text_x_size_scale, text_x_size_scale, 0);
}