// Inherit the parent event
event_inherited();

card_description = "Gain 3 shield."
/// @desc											A selected chara gains 3 shield
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_gain_shield(3)
}