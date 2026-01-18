// Inherit the parent event
event_inherited();

card_description = "Gain 2 strength."
/// @desc											A selected chara adds 2 strength to their buffs
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.add_buff_to_charas(card_buff_effects.Strength, 2)
	card_action_struct.end_card_action()
}