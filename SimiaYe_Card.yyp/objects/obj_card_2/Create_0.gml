// Inherit the parent event
event_inherited();

card_description = "1 random character deals 0.5 dmg"

/// @desc											A random chara is selected to deal 0.5 dmg
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(0.5)
	card_action_struct.end_card_action()
}