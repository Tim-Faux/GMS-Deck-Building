// Inherit the parent event
event_inherited();

card_description = "Choose a chara. Every 2 times you attack this turn they gain 1 strength"

/// @desc											Adds 1 Gain_Strength_On_Any_Attack buff to the character
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.add_buff_to_charas(card_buff_effects.Gain_Strength_On_Any_Attack, 1)
	card_action_struct.end_card_action()
}