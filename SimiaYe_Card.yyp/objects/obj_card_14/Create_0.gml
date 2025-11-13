// Inherit the parent event
event_inherited();
calc_energy_cost()

card_description = "Deal 1 dmg. This card costs 1 less for each Science character in your party"

/// @desc					A selected chara deal 1 dmg
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index], 1)
	}
}

/// @desc					Reduces the cost of the card by 1 for each Science character in the party
function calc_energy_cost() {
	var num_avaliable_charas = instance_number(obj_player)
	var allowed_attackers = array_create(0)
	for(var chara_index = 0; chara_index < num_avaliable_charas; chara_index++) {
		var chara_instance = instance_find(obj_player, chara_index)
		if(chara_instance.class == chara_class.science) {
			energy_cost--;	
		}
	}	
}