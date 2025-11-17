// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg and apply 1 Weakness."
/// @desc											A selected chara deal 0.2 dmg and applies 1 weakness to 
///														the enemy
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	for (var enemy_index = 0; enemy_index < array_length(enemy_instances); enemy_index++) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			enemy_instances[enemy_index].apply_debuffs(card_debuff_effects.Weakness, 1)
			enemy_instances[enemy_index].hit_by_player(selected_chara[chara_index], 0.2)
		}
	}
}