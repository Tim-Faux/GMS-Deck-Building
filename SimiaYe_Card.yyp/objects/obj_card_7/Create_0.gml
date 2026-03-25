// Inherit the parent event
event_inherited();

card_description = "Draw 1 card, Discard 1 card"

/// @desc											Draw 1 card into the player's hand
card_selected_action = function (remove_card_energy) {
	var cur_x_pos = x
	var cur_y_pos = y
	var drawn_card = draw_card()
	if(drawn_card != -1) {
		var add_card_succeeded = ui_player_hand.add_card(drawn_card)
		x = cur_x_pos
		y = cur_y_pos
		create_target_selection_handler(remove_card_energy)
	}
	else {
		queue_error_message(NOT_ENOUGH_CARDS_IN_DECK_TO_PLAY)	
	}
}

/// @desc											Discards 1 selected card
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.discard_selected_cards()
	card_action_struct.end_card_action()
}