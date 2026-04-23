/// @desc							Checks that the player_exhaust_deck exists and if not 
///										creates an empty array
function check_for_player_exhaust_deck() {
	if(!variable_global_exists("player_exhaust_deck")) {
		global.player_exhaust_deck = array_create(0)
	}
}

/// @desc							Gets the deck of the player's exhausted cards
function get_player_exhaust_deck() {
	check_for_player_exhaust_deck()
	return global.player_exhaust_deck
}

/// @desc							Adds a card to the exhaust deck. This does not remove it from the
///										player's deck, this must be done seperately.
/// @param {Asset.GMObject} card	The card that is being added to the player's exhaust deck
function add_card_to_exhaust_deck(card) {
	check_for_player_exhaust_deck()
	array_push(global.player_exhaust_deck, card)
}

/// @desc							Removes a card from the player's exhaust deck. This only removes it
///										from the exhaust deck, it does not handle adding it back to
///										their active deck.
/// @param {Asset.GMObject} card	The card that is being removed from the player's exhaust deck
function remove_card_from_player_exhaust_deck(card) {
	check_for_player_exhaust_deck()
	var card_index = array_get_index(global.player_exhaust_deck, card)
	array_delete(global.player_exhaust_deck, card_index, 1)
}

/// @desc							Empties out the exhaust deck, preparing it to be filled again. This
///										does not handle what to do with the cards removed but returns a
///										copy so this work can be done afterwards.
/// @returns						The exhausted cards removed from the deck
function remove_all_cards_from_player_exhaust_deck() {
	check_for_player_exhaust_deck()
	var num_exhaust_cards = array_length(global.player_exhaust_deck)
	var all_exhausted_cards = array_create_ext(num_exhaust_cards, function(_index) {
		return global.player_exhaust_deck[_index] })
	global.player_exhaust_deck = array_create(0)
	return all_exhausted_cards
}

/// @desc							Resets the player's exhaust deck by removing all cards from it
function reset_player_exhaust_deck() {
	remove_all_cards_from_player_exhaust_deck()
}