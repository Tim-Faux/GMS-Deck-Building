// Inherit the parent event
event_inherited();

card_description = "Deal 1 dmg."
/// @desc											Deal 1 damage
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1)
}