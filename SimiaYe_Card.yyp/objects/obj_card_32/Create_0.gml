// Inherit the parent event
event_inherited();

card_description = "If selected chara has shield half it and deal 1.25 dmg. Otherwise gain 2 shield"
/// @desc											If a target is selected attack them for 1.25
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1.25)
}

/// @description					Halves the characters shield and sets the defender selection type to
///										single enemy if the character has shield, otherwise give the
///										character 2 shield and set defender selection type to on emeies
/// @param {Id.Instance} selected_chara				The character selected
chara_selected_action = function (selected_chara) {
	if(selected_chara.chara_shield > 0) {
		selected_chara.chara_shield /= 2
		defender_selection_type = card_attack_target.single_enemy
	}
	else {
		selected_chara.add_shield(2)
		defender_selection_type = card_attack_target.no_enemies
	}
}