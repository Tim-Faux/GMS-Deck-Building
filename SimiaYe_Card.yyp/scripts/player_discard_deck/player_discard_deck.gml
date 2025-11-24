if(!variable_global_exists("player_discarded_deck")) {
	global.player_discarded_deck = array_create(0)
}

/// @desc							Checks that the player_discarded_deck exists and if not 
///										creates an empty array
function check_for_player_discard_deck() {
	if(!variable_global_exists("player_discarded_deck")) {
		global.player_discarded_deck = array_create(0)
	}
}

/// @desc							Gets the deck of the player's discarded cards

function get_player_discard_deck() {
	check_for_player_discard_deck()
	return global.player_discarded_deck
}

/// @desc							Adds a card to the discard deck. This does not remove it from the
///										player's deck, this must be done seperate.
/// @param {Asset.GMObject} card	The card that is being added to the player's discard deck
function add_card_to_discard_deck(card) {
	check_for_player_discard_deck()
	array_push(global.player_discarded_deck, card)
}

/// @desc							Removes a card from the player's discard deck. This only removes it
///										from the discarded deck, it does not handle adding it back to
///										their active deck.
/// @param {Asset.GMObject} card	The card that is being removed from the player's discard deck
function remove_card_from_player_discard_deck(card) {
	check_for_player_discard_deck()
	var card_index = array_get_index(global.player_discarded_deck, card)
	array_delete(global.player_discarded_deck, card_index, 1)
}

/// @desc							Empties out the discard deck, preparing it to be filled again. This
///										does not handle what to do with the cards removed but returns a
///										copy so this work can be done afterwards.
/// @returns						The cards removed from the deck
function remove_all_cards_from_player_discard_deck() {
	check_for_player_discard_deck()
	var num_discarded_cards = array_length(global.player_discarded_deck)
	var all_discarded_cards = array_create_ext(num_discarded_cards, function(_index) {
		return global.player_discarded_deck[_index] })
	global.player_discarded_deck = array_create(0)
	return all_discarded_cards
}