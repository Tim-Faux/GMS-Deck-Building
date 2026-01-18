// Inherit the parent event
event_inherited();

card_description = "All characters deals 1 dmg to an enemy"

/// @desc											All chara are selected to deal 1 dmg
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1)
	card_action_struct.end_card_action()
}