// Inherit the parent event
event_inherited();

card_description = "Deal 0.5 dmg twice."
/// @desc					Deal 0.5 damage twice
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index], 0.5)
		enemy_instance.hit_by_player(selected_chara[chara_index], 0.5)
	}
}