// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg and apply 1 Weakness."
/// @desc											A selected chara deal 0.2 dmg and applies 1 weakness to 
///														the enemy
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.apply_debuff_to_enemies(card_debuff_effects.Weakness, 1)
	card_action_struct.charas_attack_enemies(0.2)
	card_action_struct.end_card_action()
}