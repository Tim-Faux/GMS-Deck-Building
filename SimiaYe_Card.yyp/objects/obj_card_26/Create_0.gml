// Inherit the parent event
event_inherited();

card_description = "For each character selected deal 1 dmg and discard a card"

/// @desc											Each selected character deals 1 damage and 
///														discards a selected cards
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1)
	card_action_struct.discard_selected_cards()
}