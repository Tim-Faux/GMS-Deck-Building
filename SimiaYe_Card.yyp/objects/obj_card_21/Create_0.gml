// Inherit the parent event
event_inherited();

card_description = "Choose 3 cards in your discard pile to Exhaust. Deal damage equal to their cost"
target_selection_order = [selection_target.card, selection_target.character, selection_target.enemy]

/// @desc											Finds the energy cost of the selected cards before
///														exhausting them. Then attack the enemies for
///														their combined cost
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	var selected_cards_energy = card_action_struct.get_selected_cards_energy()
	card_action_struct.remove_cards_from_discard_pile()
	card_action_struct.exhaust_selected_cards()
	card_action_struct.charas_attack_enemies(selected_cards_energy)
	card_action_struct.end_card_action()
}