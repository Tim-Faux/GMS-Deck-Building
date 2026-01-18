// Inherit the parent event
event_inherited();

card_description = "Deal 0.25 dmg and apply 3 weakness"

/// @desc											Apply 3 weakness then a selected chara deal 0.25 dmg
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.apply_debuff_to_enemies(card_debuff_effects.Weakness, 3)
	card_action_struct.charas_attack_enemies(0.25)
	card_action_struct.end_card_action()
}