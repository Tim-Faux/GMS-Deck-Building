#macro DEFAULT_PLAYER_DECK [obj_battack, obj_battack, obj_battack, obj_battack, obj_battack, obj_battack, obj_battack, obj_battack, obj_battack, obj_battack]

check_for_player_full_deck()

/// @desc							Gets the player's full deck, not considering discards or temporary changes
/// @returns						Returns player's full deck of all permanent cards
function get_player_full_deck() {
	check_for_player_full_deck()
	return global.player_full_deck
}

/// @desc							Adds a permanent card to the players full deck. This should not be
///										used for temporrary cards that are removed at the end of combat
/// @param {Asset.GMObject} card	The card that is being added to the player's full deck
function add_card_to_full_player_deck(card) {
	check_for_player_full_deck()
	array_push(global.player_full_deck, card)
}

/// @desc							Permenantly removes a card from the player's deck. This should not
///										be used for discarded cards or temporary removal
/// @param {Asset.GMObject} card	The card that is being removed from the player's full deck
function remove_card_from_full_player_deck(card) {
	check_for_player_full_deck()
	var card_index = array_get_index(global.player_full_deck, card)
	array_delete(global.player_full_deck, card_index, 1)
}

/// @desc							Checks that the player_full_deck exists and if not copy it 
///										from DEFAULT_PLAYER_DECK constant
function check_for_player_full_deck() {
	if(!variable_global_exists("player_full_deck")) {
		var num_cards_in_default_deck = array_length(DEFAULT_PLAYER_DECK)
		global.player_full_deck = array_create(num_cards_in_default_deck)
		array_copy(global.player_full_deck, 0, DEFAULT_PLAYER_DECK, 0, num_cards_in_default_deck)
	}
}

/// @desc							Gets the player's current deck with discarded and temporarily
///										removed cards absent as well as temporarily added cards present
/// @returns						Returns the player's current deck
function get_player_current_deck() {
	check_for_player_current_deck()
	return global.player_current_deck
}

/// @desc							Handles drawing a single card out of the player_current_deck and
///										shuffling the discarded cards into the player_current_deck
///										when it is empty.
/// @returns {Asset.GMObject}		Returns the card drawn from player_current_deck or -1 if no
///										cards are able to be drawn
function draw_card() {
	check_for_player_current_deck()
	
	if(array_length(global.player_current_deck) < 1) {
		var discarded_cards = get_player_discard_deck()
		if(array_length(discarded_cards) < 1) {
			return -1
		}
		add_discarded_cards_to_current_deck()
	}
	var drawn_card = global.player_current_deck[random(array_length(global.player_current_deck))]
	remove_card_from_player_current_deck(drawn_card)
	return drawn_card
}

/// @desc							Puts all the cards from the discard deck into the
///										player_current_deck and shuffels them
function add_discarded_cards_to_current_deck() {
	var discarded_cards = get_player_discard_deck()
	check_for_player_current_deck()
	global.player_current_deck = array_concat(global.player_current_deck, discarded_cards)
	remove_all_cards_from_player_discard_deck()
	shuffle_player_current_deck()
}

/// @desc							Shuffles the player_current_deck to be in a random order
function shuffle_player_current_deck() {
	array_shuffle_ext(global.player_current_deck)
}

/// @desc							Adds a temporary version of a card to the player's deck. This 
///										should not be used for permanent additions to the deck
/// @param {Asset.GMObject} card	The card that is being added to the player's current deck
function add_card_to_player_current_deck(card) {
	check_for_player_current_deck()
	array_push(global.player_current_deck, card)
}

/// @desc							Temporarily removes a card from the player's hand. This should be
///										used for non-permanent changes during combat and not a 
///										permanent change to the deck
/// @param {Asset.GMObject} card	The card that is being removed from the player's current deck
function remove_card_from_player_current_deck(card) {
	check_for_player_current_deck()
	var card_index = array_get_index(global.player_current_deck, card)
	array_delete(global.player_current_deck, card_index, 1)
}

/// @desc							Checks that the player_current_deck exists and if not set it to a
///										copy of global.player_full_deck
function check_for_player_current_deck() {
	if(!variable_global_exists("player_current_deck") || global.player_current_deck == undefined) {
		check_for_player_full_deck()
		var num_cards_in_full_deck = array_length(global.player_full_deck)
		global.player_current_deck = array_create(num_cards_in_full_deck)
		array_copy(global.player_current_deck, 0, global.player_full_deck, 0, num_cards_in_full_deck)
		shuffle_player_current_deck()
	}
}