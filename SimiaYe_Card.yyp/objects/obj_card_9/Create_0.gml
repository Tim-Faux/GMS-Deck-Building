// Inherit the parent event
event_inherited();

card_description = "Draw 5 cards, Gain 6 energy, Skip next turn"

/// @desc											Draws 5 cards from the player's current deck, add 6
///														energy to player's current energy, and make it
///														so the player's next turn is skipped.
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.draw_num_cards(5)
	card_action_struct.add_energy(6)
	card_action_struct.skip_next_turn()
	card_action_struct.end_card_action()
}