// Inherit the parent event
event_inherited();

card_description = "Apply Mark to a selected Enemy. When characters attack that enemy they gain 1 shield"
/// @desc											Applies 1 Mark to an enemy, giving any character 1
///														shield when they attack that enemy
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.apply_debuff_to_enemies(card_debuff_effects.Mark, 1)
	card_action_struct.end_card_action()
}