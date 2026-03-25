// Inherit the parent event
event_inherited();

card_description = "Apply 2 wounds to an enemy"
/// @desc											Adds 2 wound effects to selected enemy
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.apply_debuff_to_enemies(card_debuff_effects.Wound, 2)

	card_action_struct.end_card_action()
}