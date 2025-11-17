// Inherit the parent event
event_inherited();

card_description = "Deal 0.1 dmg to all enemies."
/// @desc					A selected chara deal 0.1 to all enemies
card_action = function (selected_chara, enemy_instances) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		for (var enemy_index = 0; enemy_index < array_length(enemy_instances); enemy_index++) {
			enemy_instances[enemy_index].hit_by_player(selected_chara[chara_index], 0.1)
		}
	}
}