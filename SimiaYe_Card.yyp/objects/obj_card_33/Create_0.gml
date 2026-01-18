// Inherit the parent event
event_inherited();

card_description = "Deal dmg equal to the number of shields the selected character has"
/// @desc											A selected chara deal damage based on how much
///														shield they have
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.deal_dmg_to_enemies_equal_to_shield()
	card_action_struct.end_card_action()
}