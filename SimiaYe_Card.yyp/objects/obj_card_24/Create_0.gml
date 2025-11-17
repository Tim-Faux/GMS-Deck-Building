// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg per Ability card you have in hand."
/// @desc					A selected chara deal 0.2 dmg per ability card currently in hand
card_action = function (selected_chara, enemy_instance) {
	var player_current_hand = ui_player_hand.get_player_current_hand()
	var num_ability_cards = 0
	for (var card_index = 0; card_index < array_length(player_current_hand); card_index++) {
		if (player_current_hand[card_index].card_type == card_type.ability) {
			num_ability_cards++
		}
	}
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index], num_ability_cards * 0.2)
	}
}