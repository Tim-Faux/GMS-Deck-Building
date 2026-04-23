// Inherit the parent event
event_inherited();

card_description = "Discard your whole hand. Then draw 4 new cards and gain 10 energy"

/// @desc											Discards the players hand, then draws 4 new cards, 
///														excluding this one, into the player's hand and
///														add 10 energy to the player's energy pool
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.discard_selected_cards()
	card_action_struct.draw_num_cards(4)
	card_action_struct.add_energy(10)
	card_action_struct.end_card_action()
}