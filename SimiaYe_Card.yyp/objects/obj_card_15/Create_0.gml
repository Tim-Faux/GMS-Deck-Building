// Inherit the parent event
event_inherited();

card_description = "Deal 0.25 dmg and apply 3 weakness"

/// @desc					Apply 3 weakness then a selected chara deal 0.25 dmg
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.apply_debuffs(card_debuff_effects.Weakness, 2)
		enemy_instance.hit_by_player(selected_chara[chara_index], 0.25)
	}
}