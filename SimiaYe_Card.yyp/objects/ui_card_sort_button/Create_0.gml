// Inherit the parent event
event_inherited();

#macro ARROW_PADDING 5

is_sort_selected = false
is_sort_ascending = true
alpha = 1

draw_set_font(font)
setup_triangle()
set_bounding_box()

/// @desc								Sets the draw variables and draws the button text
function draw_button_text() {
	draw_set_font(font)
	draw_set_alpha(alpha)
	draw_set_colour(text_color)
	draw_text(x, y, button_text);
}

/// @desc								Calculates the required points for the indicator triangle
function setup_triangle() {
	triangle_base = y + ARROW_PADDING
	triangle_vertex = y + string_height(button_text) - (3 * ARROW_PADDING);
	
	var triangle_height = abs(triangle_vertex - triangle_base)
	triangle_left = x + string_width(button_text) + ARROW_PADDING;
	triangle_right = triangle_left + (triangle_height * arrow_width)
	triangle_center = triangle_left + ((triangle_right - triangle_left) / 2)
}

/// @desc								Sets the draw variables and draws the sort direction triangle
function draw_button_triangle() {
	if (is_sort_selected) {
		draw_set_colour(arrow_color);
		if (is_sort_ascending) {
			draw_triangle(triangle_left, triangle_base,
							triangle_right, triangle_base, 
							triangle_center, triangle_vertex, false);
		}
		else {
			draw_triangle(triangle_left, triangle_vertex,
							triangle_right, triangle_vertex, 
							triangle_center, triangle_base, false);
		}
	}
}

/// @desc								Sets the bounding box to allow button to be clicked
function set_bounding_box() {
	var button_length = triangle_right - x
	var button_height = triangle_vertex - y
	sprite_set_bbox(sprite_index, 0, 0, button_length, button_height)
}

/// @desc								Sets the sort direction for the cards
function change_sort_direction() {
	if(!is_sort_selected) {
		if(instance_exists(ui_card_grid_display)) {
			method_call(ui_card_grid_display.set_deck_default_sort, [])
		}
		ui_card_sort_button.is_sort_selected = false
		ui_card_sort_button.is_sort_ascending = true
		is_sort_selected = true
		is_sort_ascending = true
		ui_card_grid_display.sort_player_deck(sort_cards)
	}
	else if(is_sort_ascending) {
		is_sort_ascending = false
		ui_card_grid_display.sort_player_deck(sort_cards)
	}
	else if (!is_sort_ascending) {
		is_sort_ascending = true
		ui_card_grid_display.sort_player_deck(sort_cards)
	}
}

/// @desc								Sorts 2 cards
/// @param {Asset.GMObject} card1		The card at the lower index
/// @param {Asset.GMObject} card2		The card at the higher index
/// @returns							Integer that determines the sort order (<= -1: card1 goes before card2,
///										0: card1 and card2 are equal price, >= 1: card1 goes after card2
function sort_cards(card1, card2) {
	//This needs to be implemented in individual sort objects
	return 0
}