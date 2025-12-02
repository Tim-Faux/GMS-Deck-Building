// Inherit the parent event
event_inherited();

card_description = "Deal 0.1 dmg. Add a copy of this card to hand when drawn."
/// @desc											Deals 0.1 damage
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(0.1)
}

/// @desc											Add a copy of this card to the player's hand
card_drawn_action = function () {
	ui_player_hand.add_copy_of_card_to_hand(id)
}