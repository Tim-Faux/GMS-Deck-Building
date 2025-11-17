// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg per Ability card you have in hand."
/// @desc											A selected chara deal 0.2 dmg per ability card currently
///														in hand
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	var player_current_hand = ui_player_hand.get_player_current_hand()
	var num_ability_cards = 0
	for (var card_index = 0; card_index < array_length(player_current_hand); card_index++) {
		if (player_current_hand[card_index].card_type == card_type.ability) {
			num_ability_cards++
		}
	}
	for (var enemy_index = 0; enemy_index < array_length(enemy_instances); enemy_index++) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			enemy_instances[enemy_index].hit_by_player(selected_chara[chara_index], num_ability_cards * 0.2)
		}
	}
}