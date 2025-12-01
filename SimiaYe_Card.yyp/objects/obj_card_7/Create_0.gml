// Inherit the parent event
event_inherited();

card_description = "Discard 1 card, Draw 1 card"

/// @desc											Discards 1 selected card then draws a card
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.discard_selected_cards()
	card_action_struct.draw_num_cards(1)
}