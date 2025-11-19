// Inherit the parent event
event_inherited();

card_description = "Gain 3 shield."
/// @desc											A selected chara gains 3 shield
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		selected_chara[chara_index].add_shield(3)
	}
}