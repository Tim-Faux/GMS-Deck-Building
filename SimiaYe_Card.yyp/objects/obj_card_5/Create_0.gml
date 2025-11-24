// Inherit the parent event
event_inherited();

card_description = "Each character gains 1 Shield"

/// @desc											Give all avaliable chara 1 shield
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_gain_shield(1)
}