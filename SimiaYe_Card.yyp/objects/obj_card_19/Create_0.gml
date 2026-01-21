// Inherit the parent event
event_inherited();

card_description = "If this card is in hand when your turn ends a random chara deals damage equal to the number of cards in hand"
on_end_turn_action = undefined
on_end_turn_action_args = []

/// @desc											Deal damage equal to the number of cards in hand
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	var num_cards_in_hand = array_length(ui_player_hand.get_player_current_hand())
	card_action_struct.charas_attack_enemies(num_cards_in_hand)
	
	if(on_end_turn_action != undefined && is_method(on_end_turn_action))
		method_call(on_end_turn_action, on_end_turn_action_args)
	card_action_struct.end_card_action()
}

/// @desc											Plays this card when the player ends their turn
/// @param {Function} on_end_turn_action			The call back function for after the end turn 
///														action completes
/// @param {Array} on_end_turn_action_args			The argurments for the on_end_turn_action function
player_turn_end_action = function (on_end_turn_action, on_end_turn_action_args) {
	self.on_end_turn_action = on_end_turn_action
	self.on_end_turn_action_args = on_end_turn_action_args
	play_card()
}