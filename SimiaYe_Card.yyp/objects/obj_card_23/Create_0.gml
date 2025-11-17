// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg per energy you currently have."
/// @desc					A selected chara deal 0.2 dmg per energy currently avaliable
card_action = function (selected_chara, enemy_instance) {
	var energy_before_card_played = ui_player_energy.get_player_current_energy() + energy_cost
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index], energy_before_card_played * 0.2)
	}
}