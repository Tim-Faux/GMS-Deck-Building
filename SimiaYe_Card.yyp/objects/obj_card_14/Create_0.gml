// Inherit the parent event
event_inherited();
calc_energy_cost();

card_description = "Deal 1 dmg. This card costs 1 less for each Science character in your party"

/// @desc											A selected chara deal 1 dmg
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1)
	card_action_struct.end_card_action()
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