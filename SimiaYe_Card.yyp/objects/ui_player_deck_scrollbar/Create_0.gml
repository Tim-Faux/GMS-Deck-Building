#macro SCROLL_BORDER_WIDTH 2
#macro SCROLL_SMOOTHING_AMOUNT 0.25

scroll_clicked = false
amount_page_scrolled = 0

var thumb_scale = find_scroll_thumb_scale()

amount_bar_moves = find_scroll_wheel_scaling()
scroll_min = y + floor(SCROLL_BORDER_WIDTH * image_yscale)
scroll_max = find_scroll_thumb_max(thumb_scale)
scroll_thumb = create_scroll_thumb(scroll_min, scroll_max, thumb_scale)
pos_thumb_clicked = 0

/// @desc								Finds the scroll scaling needed to move 1 card
/// @returns							The scroll scaling needed to show 1 new card
function find_scroll_wheel_scaling() {
	var max_scroll_thumb_y = (sprite_height - (2 * SCROLL_BORDER_WIDTH * image_yscale))
	if(instance_number(obj_display_card) > 0) {
		// This assumes all cards are the same size, right now that is true and the alternative requires
		// looping through all the cards
		var card_height = instance_find(obj_display_card, 1).sprite_height
		var num_card_rows = list_of_card_height / (card_height + CARD_PADDING)
		return max_scroll_thumb_y / num_card_rows
	}
	return 0
}

/// @desc								Creates the scroll bar thumb that shows the user where on the screen
///											they are scrolled to
/// @param {Real} scroll_min			The highest position on screen the scroll thumb can go to
/// @param {Real} scroll_max			The lowest position on screen the scroll thumb can go to
/// @param {Real} thumb_scale			The amount the scroll thumb sprite is scaled
/// @returns							The new scroll thumb instance
function create_scroll_thumb(scroll_min, scroll_max, thumb_scale) {
	var thumb_layer_depth = layer_get_depth(layer) - 1
	var player_deck_scroll_thumb_instance_id = layer_create(thumb_layer_depth, "player_deck_scroll_thumb_instance")
	return instance_create_layer(x + SCROLL_BORDER_WIDTH, scroll_min, player_deck_scroll_thumb_instance_id, ui_player_deck_scroll_thumb, {
		image_yscale : thumb_scale
	})
}

/// @desc								Finds the maximum y position of the scroll thumb scaled to 
///											thumb_scale such that it will stay within the bar
/// @param {Real} thumb_scale			The amount the scroll thumb sprite is scaled (default 1)
/// @returns							The maximum y value of the thumb such that it stays in its bar
function find_scroll_thumb_max(thumb_scale = 1) {
	var thumb_sprite_height = sprite_get_height(object_get_sprite(ui_player_deck_scroll_thumb)) * thumb_scale
	return y + sprite_height - floor(SCROLL_BORDER_WIDTH * image_yscale) - thumb_sprite_height
}

/// @desc								Finds the amount that the scroll thumb will need to be scaled to
///											such that it will reflect how many screen lengths are below
///											what is shown. (1 screen length hidden = 1/2 the scroll bar)
/// @returns							The scroll thumb scaling (minimum: no scaling, maximum: the inner
///											portion of the bar)
function find_scroll_thumb_scale() {
	var max_scroll_thumb_scale = (sprite_height - (2 * SCROLL_BORDER_WIDTH * image_yscale))
									/ sprite_get_height(object_get_sprite(ui_player_deck_scroll_thumb))
	var deck_view_window = display_get_gui_height() - header_bottom_y
	var num_screen_lengths = deck_view_window / list_of_card_height
	return clamp(max_scroll_thumb_scale * num_screen_lengths, 1, max_scroll_thumb_scale)
}

/// @desc								Moves the scroll bar thumb to the new position as well as moving
///											all of the display cards that exist after using the scroll
///											wheel or clicking on the bar
/// @param {bool} smooth_scroll			Flag to determine if the scroll should be animated or not
/// @param {Real} thumb_scroll_min		The highest position on screen the scroll thumb can go to
///											(default to global variable)
/// @param {Real} thumb_scroll_max		The lowest position on screen the scroll thumb can go to
///											(default to global variable)
function move_scroll_thumb(smooth_scroll, thumb_scroll_min = scroll_min, thumb_scroll_max = scroll_max) {
	if(smooth_scroll) {
		scroll_thumb.y = lerp(scroll_thumb.y, amount_page_scrolled, SCROLL_SMOOTHING_AMOUNT);
	}
	else {
		scroll_thumb.y = amount_page_scrolled
	}
		
	for (var movable_objects_index = 0; movable_objects_index < instance_number(obj_display_card); movable_objects_index++)
	{
		var display_card = instance_find(obj_display_card, movable_objects_index);
		var percent_scrolled = (scroll_thumb.y - thumb_scroll_min) / (thumb_scroll_max - thumb_scroll_min)
		var card_grid_display_height = display_get_gui_height() - header_bottom_y
		display_card.y = display_card.ystart - (percent_scrolled * 
							(list_of_card_height - card_grid_display_height))
	}
}