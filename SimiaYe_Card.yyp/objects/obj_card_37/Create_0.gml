// Inherit the parent event
event_inherited();

card_description = "Deal 0.25 dmg 4 times."
/// @desc											A selected chara deal 0.25 dmg 4 times
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	repeat(4) {
		card_action_struct.charas_attack_enemies(0.25)
	}
}