// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg and apply 1 Weakness."
/// @desc					A selected chara deal 0.2 dmg and applies 1 weakness to the enemy
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.apply_debuffs(card_debuff_effects.Weakness, 1)
		enemy_instance.hit_by_player(selected_chara[chara_index], 0.2)
	}
}