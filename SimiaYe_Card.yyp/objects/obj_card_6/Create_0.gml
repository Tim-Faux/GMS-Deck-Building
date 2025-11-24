// Inherit the parent event
event_inherited();

card_description = "Heal 1 character for 1 health"

/// @desc											A selected chara is healed 1 health
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_heal(1)
}