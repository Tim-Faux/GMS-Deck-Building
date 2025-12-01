// Inherit the parent event
event_inherited();

card_description = "Draw 1 card"

/// @desc											Draws 1 card
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.draw_num_cards(1)
}