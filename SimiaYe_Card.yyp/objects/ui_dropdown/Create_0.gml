#macro DROPDOWN_TEXT_PADDING 10
#macro DROPDOWN_ARROW_VERTICAL_PADDING 20
#macro DROPDOWN_ARROW_RIGHT_PADDING 15
#macro DROPDOWN_BORDER_WIDTH 3

// These options should be implemented in each ui_dropdown_options
dropdown_items = []

dropdown_clicked = false
dropdown_release_num = 0
dropdown_options_instances = []
get_dropdown_options_layer()
setup_triangle()

if(!variable_global_exists("object_being_clicked")) {
	global.object_being_clicked = false
}

/// @desc					Finds or creates the layer the dropdown options should be in and puts the id
///								in drop_down_options_layer
function get_dropdown_options_layer() {
	var layer_name = "drop_down_options"
	if(!layer_exists(layer_name)) {
		drop_down_options_layer = layer_create(depth - 1, layer_name)
	}
	else {
		drop_down_options_layer = layer_get_id(layer_name)
	}
}

/// @desc					Creates ui_drop_down_options for each of the dropdown_item options and places
///								their instance id in dropdown_options_instances
function show_drop_down_options() {
	var num_options = array_length(dropdown_items)
	dropdown_options_instances = array_create(num_options)
	
	get_dropdown_options_layer()
	var first_option_y_pos = y + (sprite_height / 2)
	var options_height = sprite_get_height(object_get_sprite(ui_dropdown_option))
	for(var option_index = 0; option_index < num_options; option_index++) {
		var y_pos = first_option_y_pos + (options_height * option_index)
		dropdown_options_instances[option_index] = instance_create_layer(x, y_pos, drop_down_options_layer, ui_dropdown_option, {
			option_text : dropdown_items[option_index]
		})
	}
}

/// @desc					Checks if any of the dropdown options were clicked and destroys the layer
function close_dropdown() {
	dropdown_clicked = false
	global.object_being_clicked = false
	
	for(var option_index = 0; option_index < array_length(dropdown_options_instances); option_index++) {
		if(position_meeting(mouse_x, mouse_y, dropdown_options_instances[option_index])) {
			selected_value = dropdown_options_instances[option_index].option_text
			handle_option_clicked()
			break;
		}
	}
	layer_destroy(drop_down_options_layer)
}

/// @desc					Handles what happens when the ui_dropdown_option is selected
function handle_option_clicked() {
	event_user(0)
}

/// @desc					Draws the text for the selected dropdown option
function draw_selected_option_text() {
	var text_height = string_height(selected_value);
	var text_width = string_width(selected_value);
	var text_y_size_scale = 1;
	var text_x_size_scale = 1;
	if ((sprite_height - (DROPDOWN_OPTION_TEXT_PADDING * 2)) > 0 && text_height > 
			(sprite_height - (DROPDOWN_OPTION_TEXT_PADDING * 2))) {
	    text_y_size_scale = (sprite_height - (DROPDOWN_OPTION_TEXT_PADDING * 2)) / text_height;
	}
	if ((sprite_width - (DROPDOWN_OPTION_TEXT_PADDING * 2)) > 0 && text_height > 
			(sprite_width - (DROPDOWN_OPTION_TEXT_PADDING * 2))) {
	    text_x_size_scale = (sprite_width - (DROPDOWN_OPTION_TEXT_PADDING * 2)) / text_width;
	}
	if(text_y_size_scale < text_x_size_scale)
		draw_text_transformed(x + DROPDOWN_BORDER_WIDTH + DROPDOWN_TEXT_PADDING, y,
								selected_value, text_y_size_scale, text_y_size_scale, 0);
	else
		draw_text_transformed(x + DROPDOWN_BORDER_WIDTH + DROPDOWN_TEXT_PADDING, y,
								selected_value, text_x_size_scale, text_x_size_scale, 0);
}

/// @desc					Calculates the required points for the indicator triangle
function setup_triangle() {
	var arrow_y_size = (sprite_height - (DROPDOWN_ARROW_VERTICAL_PADDING * 2 * image_yscale))
	triangle_bottom = y + (sprite_height / 2) - (DROPDOWN_ARROW_VERTICAL_PADDING * image_yscale)
	triangle_top = y - (sprite_height / 2) + (DROPDOWN_ARROW_VERTICAL_PADDING * image_yscale)
	
	var triangle_height = abs(triangle_top - triangle_bottom)
	var space_from_right_edge = (DROPDOWN_BORDER_WIDTH + DROPDOWN_ARROW_RIGHT_PADDING) * image_xscale
	triangle_right = x + sprite_width - space_from_right_edge
	triangle_left = triangle_right - (triangle_height * arrow_width)
	triangle_center = (triangle_right + triangle_left) / 2
}

/// @desc					Sets the draw variables and draws the indicator triangle
function draw_indicator_triangle() {
	setup_triangle()
	draw_set_colour(arrow_color);
	if (!dropdown_clicked) {
		draw_triangle(triangle_left, triangle_bottom,
						triangle_right, triangle_bottom, 
						triangle_center, triangle_top, false);
	}
	else {
		draw_triangle(triangle_left, triangle_top,
						triangle_right, triangle_top, 
						triangle_center, triangle_bottom, false);
	}
}