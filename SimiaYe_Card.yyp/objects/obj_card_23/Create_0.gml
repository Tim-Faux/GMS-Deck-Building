// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg per energy you currently have."
/// @desc											A selected chara deal 0.2 dmg per energy currently 
///														avaliable
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	var energy_before_card_played = ui_player_energy.get_player_current_energy() + energy_cost
	for (var enemy_index = 0; enemy_index < array_length(enemy_instances); enemy_index++) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			enemy_instances[enemy_index].hit_by_player(selected_chara[chara_index], energy_before_card_played * 0.2)
		}
	}
}