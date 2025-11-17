// Inherit the parent event
event_inherited();

card_description = "1 random character deals 0.5 dmg"

/// @desc											A random chara is selected to deal 0.5 dmg
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	for (var enemy_index = 0; enemy_index < array_length(enemy_instances); enemy_index++) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			enemy_instances[enemy_index].hit_by_player(selected_chara[chara_index], 0.5)
		}
	}
}