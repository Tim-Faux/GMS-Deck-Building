// Inherit the parent event
event_inherited();

card_description = "Double your current energy. Exhaust."

/// @desc											Multiples the player's current energy by 2
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.mult_energy(2)
}