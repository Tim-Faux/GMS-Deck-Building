#macro EXPANDED_CARD_PADDING 100

remove_expanded_card = false

/// @desc								Draws a rectangle over the whole camera to dim the game
///											NOTE: this must be called in the Draw event or it won't
///											work correctly
function draw_deck_background() {
	draw_set_colour(c_black)
	draw_set_alpha(BACKGROUND_ALPHA)
	var screen_width = display_get_gui_width()
	var screen_height = display_get_gui_height()
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)	
}