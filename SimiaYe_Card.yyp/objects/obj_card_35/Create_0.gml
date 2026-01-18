// Inherit the parent event
event_inherited();

card_description = "Doubles the character's Strength."
/// @desc											Multiplies a selected chara's Strength by 2
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.mult_charas_buff(card_buff_effects.Strength, 2)
	card_action_struct.end_card_action()
}