// Inherit the parent event
event_inherited();

card_description = "All characters deals 1 dmg to an enemy"

/// @description							A all chara are selected to deal 1 dmg
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index], 1)
	}
}