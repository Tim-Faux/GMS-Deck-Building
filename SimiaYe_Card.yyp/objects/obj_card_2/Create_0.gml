// Inherit the parent event
event_inherited();

card_description = "1 random character deals 0.5 dmg"

/// @description							A random chara is selected to deal 0.5 dmg
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index], 0.5)
	}
}