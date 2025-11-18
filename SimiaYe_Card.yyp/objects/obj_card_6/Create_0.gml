// Inherit the parent event
event_inherited();

card_description = "Heal 1 character for 1 health"

/// @desc											A selected chara is healed 1 health
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		selected_chara[chara_index].heal_chara(1)
	}
}