// Inherit the parent event
event_inherited();

card_description = "Deal 0.5 dmg twice."
/// @desc											Deal 0.5 damage twice
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(0.5)
	card_action_struct.charas_attack_enemies(0.5)
	card_action_struct.end_card_action()
}