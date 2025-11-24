// Inherit the parent event
event_inherited();

card_description = "Deal 0.1 dmg to all enemies."
/// @desc					A selected chara deal 0.1 to all enemies
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(0.1)
}