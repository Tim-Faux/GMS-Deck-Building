#macro CARD_PADDING 10
#macro BACKGROUND_ALPHA 0.5
#macro SCROLL_BAR_PADDING 5

bottom_of_header = 0
height_of_card_list = 0
display_cards = []
scroll_bar = noone

var header_depth = layer_get_depth(layer) - 5
var card_display_header_instance_id = layer_create(header_depth, "card_display_header_instance")
create_card_display_header(card_display_header_instance_id)
create_card_grid_view()

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
		image_yscale : header_sprite_scale,
		on_deck_view_closed,
		on_deck_view_closed_args
	})
}

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
		var screen_width = display_get_gui_width()
		var num_columns = floor(screen_width / (card_width + CARD_PADDING))
		var num_rows = ceil(array_length(cards_to_display) / num_columns)
		height_of_card_list = ((card_height + CARD_PADDING) * num_rows) + CARD_PADDING
		var flexpanels = create_card_flexpanels(card_width, card_height)
		display_cards = array_create(array_length(cards_to_display))
	
		for (var card_index = 0; card_index < array_length(cards_to_display); card_index++) {
			var card_x_pos = card_index % num_columns * (card_width + CARD_PADDING) + CARD_PADDING
			var card_y_pos = bottom_of_header + (floor(card_index / num_columns) * 
								(card_height + CARD_PADDING)) + CARD_PADDING

			var display_card = instance_create_layer(card_x_pos, card_y_pos, card_display_instance_id, cards_to_display[card_index], {
				flexpanels,
				interaction_type : [card_interaction_type.display_card,
									cards_are_selectable ? card_interaction_type.selectable_card :
															card_interaction_type.expandable_card]
			})
			display_cards[card_index] = display_card
		}
		set_deck_default_sort()
		set_cards_initial_pos(display_cards)
		
		create_scroll_bar(display_cards)
	}
}

/// @desc										Sets all of the card instances positions, based on their
///													position in display_cards
/// @param {Array<Id.Instance>} display_cards	The layer the header will be shown on
function set_cards_initial_pos(display_cards) {
	//This assumes the cards will always be the same size. As of right now that's true and to make it
	//	more generic would result in a potentially worse solution
	var card_width = display_cards[0].sprite_width
	var card_height = display_cards[0].sprite_height
	var screen_width = display_get_gui_width()
	var num_columns = floor(screen_width / (card_width + CARD_PADDING))
	var num_rows = ceil(array_length(display_cards) / num_columns)
	height_of_card_list = ((card_height + CARD_PADDING) * num_rows) + CARD_PADDING
	
	for (var card_index = 0; card_index < array_length(display_cards); card_index++) {
		display_cards[card_index].x = card_index % num_columns * (card_width + CARD_PADDING) + CARD_PADDING
		display_cards[card_index].y = bottom_of_header + (floor(card_index / num_columns) * 
							(card_height + CARD_PADDING)) + CARD_PADDING
		display_cards[card_index].ystart = display_cards[card_index].y
		display_cards[card_index].xstart = display_cards[card_index].x
	}
	
	if(scroll_bar != noone) {
		scroll_bar.objects_to_move = display_cards
		scroll_bar.set_card_to_scroll_pos()
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
function create_scroll_bar(objects_to_move) {
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
		scroll_bar = instance_create_layer(bar_x_pos, bar_y_pos, scroll_bar_instance_id, ui_player_deck_scrollbar, {
			image_yscale : bar_sprite_y_scale,
			header_bottom_y : bottom_of_header,
			scrollable_list_height : height_of_card_list,
			objects_to_move
		})
	}
}

/// @desc									Sorts the display_cards array using the given sort function,
///												then repositions all of the cards to match the sorting
/// @param {Function} sort_function			The function used to determine cards ordering. For more info
///												see array_sort manual
function sort_player_deck(sort_function) {
	array_sort(display_cards, sort_function)
	set_cards_initial_pos(display_cards)
}

/// @desc									Sets the default sorting for the deck, which is based on
///												the cards energy cost
function set_deck_default_sort() {
	if(instance_exists(ui_card_sort_by_cost)) {
		ui_card_sort_by_cost.is_sort_selected = true
		ui_card_sort_by_cost.is_sort_ascending = true
		sort_player_deck(ui_card_sort_by_cost.sort_cards)
	}
	else {
		sort_player_deck(default_sort_function)
	}
}

/// @desc									Sorts 2 cards by determining which costs more
/// @param {Id.Instance} card1				The card at the lower index
/// @param {Id.Instance} card2				The card at the higher index
/// @returns								Integer that determines the sort order <= -1: card1 goes
///												before card2, 0: card1 and card2 are equal price, 
///												>= 1: card1 goes after card2
function default_sort_function(card1, card2) {
	return card2.energy_cost - card1.energy_cost 
}