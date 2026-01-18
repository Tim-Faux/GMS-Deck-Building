// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg per Ability card you have in hand."
/// @desc											A selected chara deal 0.2 dmg per ability card currently
///														in hand
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	var num_ability_cards = get_num_ability_cards_in_hand()
	card_action_struct.charas_attack_enemies(num_ability_cards * 0.2)
	card_action_struct.end_card_action()
}

/// @desc											Loops through all cards in the player's hand to find the
///														number of ability cards
/// @returns										The number of ability cards currently in hand
function get_num_ability_cards_in_hand() {
	var player_current_hand = ui_player_hand.get_player_current_hand()
	var num_ability_cards = 0
	for (var card_index = 0; card_index < array_length(player_current_hand); card_index++) {
		if (player_current_hand[card_index].card_type == card_type.ability) {
			num_ability_cards++
		}
	}
	return num_ability_cards
}