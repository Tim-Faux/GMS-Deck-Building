// Inherit the parent event
event_inherited();

card_description = "Look at the top card of your draw pile"

/// @desc											Displays the top card of the player's deck
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	var displayed_cards_layer = layer_create(depth - 200, "expanded_card_instance")
	card_action_struct.show_selected_cards(displayed_cards_layer,
											method(self, card_display_finished),
											[card_action_struct])
}

/// @desc											The callback function for show_selected_cards, calling
///														the end card action for this card
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
function card_display_finished(card_action_struct) {
	card_action_struct.end_card_action()
}