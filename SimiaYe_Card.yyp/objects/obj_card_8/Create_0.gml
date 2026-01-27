// Inherit the parent event
event_inherited();

card_description = "Restore 8 health. This card remains in hand until discarded, then take 10 dmg"
on_card_discard = undefined
on_card_discard_args = []

/// @desc											Restore 8 health on a character, or deal 10 damage
///														to a selected character on discard
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	energy_cost = 4
	if(card_is_discarded_when_played) {
		card_action_struct.damage_selected_charas(10)
	}
	else {
		card_action_struct.charas_heal(8)
	}
	card_action_struct.end_card_action()
}

/// @description								Allows the player to select a character to take damage
///													when this card is discarded
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
		card_is_discarded_when_played = true
		card_is_exhausted_when_played = false
		cancel_button_allowed = false
		self.on_card_discard = on_card_discard
		self.on_card_discard_args = on_card_discard_args
		play_card(false)
	}
}