#macro CARD_PADDING 10
#macro BACKGROUND_ALPHA 0.5
#macro SCROLL_BAR_PADDING 5

bottom_of_header = 0
height_of_card_list = 0

var header_depth = layer_get_depth(layer) - 5
var card_display_header_instance_id = layer_create(header_depth, "card_display_header_instance")
create_card_display_header(card_display_header_instance_id)

create_card_grid_view()
create_scroll_bar()

/// @desc									Creates the header that displays above the player deck
/// @param {String, Id.Layer} layer_id		The layer the header will be shown on
function create_card_display_header(layer_id) {
	var header_x_pos = 0
	var header_y_pos = 0
	var header_sprite_width = sprite_get_width(object_get_sprite(ui_player_deck_header_background))
	var header_sprite_scale = display_get_gui_width() / header_sprite_width
	bottom_of_header = header_y_pos + 
						(sprite_get_height(object_get_sprite(ui_player_deck_header_background)) * 
						header_sprite_scale)
	instance_create_layer(header_x_pos, header_y_pos, layer_id, ui_player_deck_header_background, {
		image_xscale : header_sprite_scale,
		image_yscale : header_sprite_scale
	})
}


//TODO need to make this more genaric for any card array
/// @desc									Displays all of the players cards in their current deck in a grid
function create_card_grid_view() {
	if(array_length(cards_to_display) > 0) {
		var card_display_layer_name = "card_display_grid_instance"
		var card_display_instance_id = layer_get_id(card_display_layer_name)
		if(card_display_instance_id == -1) {
			var card_grid_depth = layer_get_depth(layer) - 1
			card_display_instance_id = layer_create(card_grid_depth, card_display_layer_name)
		}
		//This assumes the cards will always be the same size. As of right now that's true and to make it
		//	more generic would result in a potentially worse solution
		var card_width = sprite_get_width(object_get_sprite(cards_to_display[0]))
		var card_height = sprite_get_height(object_get_sprite(cards_to_display[0]))
		var default_camera_id = camera_get_default()
		var screen_width = camera_get_view_width(default_camera_id)
		var num_columns = floor(screen_width / (card_width + CARD_PADDING))
		var num_rows = ceil(array_length(cards_to_display) / num_columns)
		height_of_card_list = ((card_height + CARD_PADDING) * num_rows) + CARD_PADDING
		
		for (var card_index = 0; card_index < array_length(cards_to_display); card_index++) {
			var card_x_pos = card_index % num_columns * (card_width + CARD_PADDING) + CARD_PADDING
			var card_y_pos = bottom_of_header + (floor(card_index / num_columns) * 
								(card_height + CARD_PADDING)) + CARD_PADDING
			
			instance_create_layer(card_x_pos, card_y_pos, card_display_instance_id, obj_display_card, {
				sprite_index : object_get_sprite(cards_to_display[card_index])
			})
		}
	}
}

/// @desc									Draws a rectangle over the whole camera to dim the game
///												NOTE: this must be called in the Draw event or it won't
///												work correctly
function draw_card_grid_background() {
	draw_set_colour(c_black)
	draw_set_alpha(BACKGROUND_ALPHA)
	var default_camera_id = camera_get_default()
	var screen_width = camera_get_view_width(default_camera_id)
	var screen_height = camera_get_view_height(default_camera_id)
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)
}

/// @desc									Creates a scroll bar to move all display cards
function create_scroll_bar() {
	if((bottom_of_header + height_of_card_list) > display_get_gui_height()) {
		var scroll_bar_layer_name = "scroll_bar_instance"
		var scroll_bar_instance_id = layer_get_id(scroll_bar_layer_name)
		if(scroll_bar_instance_id == -1) {
			var scroll_bar_grid_depth = layer_get_depth(layer) - 1
			scroll_bar_instance_id = layer_create(scroll_bar_grid_depth, scroll_bar_layer_name)
		}
		var bar_sprite_width = sprite_get_width(object_get_sprite(ui_player_deck_scrollbar))
		var bar_sprite_height = sprite_get_height(object_get_sprite(ui_player_deck_scrollbar))
		var bar_x_pos = display_get_gui_width() - SCROLL_BAR_PADDING - bar_sprite_width
		var bar_y_pos = bottom_of_header + SCROLL_BAR_PADDING
		var bar_sprite_y_scale = (display_get_gui_height() - bar_y_pos -  SCROLL_BAR_PADDING) / bar_sprite_height
		instance_create_layer(bar_x_pos, bar_y_pos, scroll_bar_instance_id, ui_player_deck_scrollbar, {
			image_yscale : bar_sprite_y_scale,
			list_of_card_height : height_of_card_list,
			header_bottom_y : bottom_of_header
		})
	}
}

/// @desc									Clears out the displayed cards, sorts the displayed deck,
///												and recreates them to be visable to the player
function sort_player_deck(sort_function) {
	for (var display_card_index = 0; display_card_index < instance_number(obj_display_card); display_card_index++)
	{
		instance_destroy(instance_find(obj_display_card,display_card_index))
	}
	
	array_sort(cards_to_display, sort_function)
	create_card_grid_view()
}