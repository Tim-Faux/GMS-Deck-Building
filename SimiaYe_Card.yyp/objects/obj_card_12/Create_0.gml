// Inherit the parent event
event_inherited();

card_description = "On discard deal 1 damage"
on_card_discard = undefined
on_card_discard_args = []

/// @desc											A selected chara deal 1 dmg
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1)
	card_action_struct.end_card_action()
}

/// @description								Allows the player to select a target to attack when
///													this card is discarded
/// @param {Function} on_card_discard			The call back function for after the card is discarded
/// @param {Array} on_card_discard_args			The argurments for the on_card_discard function
card_discard_action = function(on_card_discard, on_card_discard_args) {
	if(card_played) {
		if(self.on_card_discard != undefined && is_method(self.on_card_discard))
			method_call(self.on_card_discard, self.on_card_discard_args)
		ui_player_hand.remove_card(id)
	}
	else {
		card_played = true
		self.on_card_discard = on_card_discard
		self.on_card_discard_args = on_card_discard_args
		play_card()
	}
}