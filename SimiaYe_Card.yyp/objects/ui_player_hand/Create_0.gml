#macro SPACE_BETWEEN_CARDS_IN_HAND 1
#macro DEFAULT_PLAYER_HAND_SIZE 6
#macro MAX_PLAYER_HAND_SIZE 16

player_hand_size = DEFAULT_PLAYER_HAND_SIZE
cards_in_hand = array_create(0)
is_hand_visible = true
total_width_of_hand = 0
run_card_drawn_functions = false

initial_hand_setup()

/// @desc			Setsup the player's initial hand, adding cards to fill the player_hand_size
function initial_hand_setup() {
	global.player_current_deck = undefined
	fill_player_hand()
}

/// @desc			Adds cards to the player's hand until they have player_hand_size amount
function fill_player_hand() {
	var number_of_cards_in_hand = array_length(cards_in_hand)
	var num_cards_needed = player_hand_size - number_of_cards_in_hand
	if(num_cards_needed > 0) {
		if(num_cards_needed > 1) {
			var cards_to_add = array_create(num_cards_needed, -1)
			for(var card_num = 0; card_num < num_cards_needed; card_num++) {
				var drawn_card = draw_card()
				if(drawn_card == -1) {
					array_resize(cards_to_add, card_num)
					break;
				}
				else {
					cards_to_add[card_num] = drawn_card
				}
			}
			add_multiple_cards(cards_to_add)
		}
		else {
			var drawn_card = draw_card()
			if(drawn_card != -1)
				add_card(drawn_card)
		}
	}
}

/// @desc							Removes all cards from the player's hand, puts them in the
///										discard deck, and destroys their instnace
function empty_player_hand() {
	array_foreach(cards_in_hand, function(card, card_index) {
		add_card_to_discard_deck(card.object_index)
		instance_destroy(card)
	})
	array_resize(cards_in_hand, 0)
}

/// @desc							Finds all the cards in the player's current hand
/// @returns						An array of the cards currently in the player's hand
function get_player_current_hand() {
	return cards_in_hand
}

/// @desc							Adds a specified card to the player's hand and shows it in the UI
/// @param {Asset.GMObject} card	The card that is being added to the player's hand
/// @returns {bool}					True if the card was added to the player's hand or false and it was
///										returned to the top of the player's deck
function add_card(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card)
	var number_of_cards_in_hand = array_length(cards_in_hand)
	if(number_of_cards_in_hand < MAX_PLAYER_HAND_SIZE) {
		array_push(cards_in_hand, card_instance)
		set_cards_in_hand_position()
		card_instance.card_drawn_action()
		return true
	}
	else {
		add_card_to_top_of_player_current_deck(card)
		return false
	}
}

/// @desc							Adds multiple specified cards to the player's hand 
///										and shows it in the UI
/// @param {Array} cards			The cards that are being added to the player's hand
function add_multiple_cards(cards) {
	var current_num_cards_in_hand = array_length(cards_in_hand)
	var new_array_length = current_num_cards_in_hand + array_length(cards)
	array_resize(cards_in_hand, new_array_length)
	for(var card_index = 0; card_index < array_length(cards); card_index++) {
		var card_instance = instance_create_layer(x, y, "Instances", cards[card_index])
		cards_in_hand[card_index + current_num_cards_in_hand] = card_instance
	}
	run_card_drawn_functions = true
	set_cards_in_hand_position()
}

/// @desc							Creates a copy of the given card in the player's hand
/// @param {Id.Instance} card		The card that is being copied
function add_copy_of_card_to_hand(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card.object_index)
	var number_of_cards_in_hand = array_length(cards_in_hand)
	if(number_of_cards_in_hand < MAX_PLAYER_HAND_SIZE) {
		var card_index = array_get_index(cards_in_hand, card)
		if(card_index != -1)
			array_insert(cards_in_hand, card_index + 1, card_instance)
		else
			array_push(cards_in_hand, card_instance)
		set_cards_in_hand_position()
		return true
	}
	else {
		add_card_to_top_of_player_current_deck(card)
		return false
	}
}

/// @desc							Removes the given card from the players hand if it exists
/// @param {Id.Instance} card		The card that is being removed from the player's hand
function remove_card(card) {
	for(var card_index = 0; card_index < array_length(cards_in_hand); card_index++) {
		if (cards_in_hand[card_index].id == card.id) {
			instance_destroy(card)
			array_delete(cards_in_hand, card_index, 1)
			set_cards_in_hand_position()
			break
		}
	}
}

/// @desc			Sets the position of all of the player's cards to be at the bottom center of the screen
function set_cards_in_hand_position() {
	var total_width_of_hand = get_width_of_player_hand()
	var next_card_x = (display_get_gui_width() - total_width_of_hand) / 2
	for(var card_index = 0; card_index < array_length(cards_in_hand); card_index++) {
		if(cards_in_hand[card_index] != 0) {
			cards_in_hand[card_index].x = next_card_x
			cards_in_hand[card_index].y = display_get_gui_height() - cards_in_hand[card_index].sprite_height
			next_card_x += cards_in_hand[card_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		}
	}
}

/// @desc			Loop through the player's hand to find the total width of all card sprites
/// @returns		The total width of the player's current hand
function get_width_of_player_hand() {
	var total_width_of_hand = 0
	
	for(var hand_index = 0; hand_index < array_length(cards_in_hand); hand_index++) {
		if(cards_in_hand[hand_index] != 0) {
			total_width_of_hand += cards_in_hand[hand_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		}
		else {
			//This shouldnt ever happen, but it will cause issues if the array isn't kept in check
			array_delete(cards_in_hand, hand_index, 1)
			hand_index--
		}
	}
	return total_width_of_hand
}

/// @desc							Runs the card_drawn_action for each of the cards in hand. This
///										is intended to only be called when the player is drawing a
///										completely new hand.
function run_card_drawn_code() {
	for(var card_index = array_length(cards_in_hand) - 1; card_index >= 0; card_index--) {
		cards_in_hand[card_index].card_drawn_action()
	}
}

/// @desc							Makes all the cards in the player's hand visible
function show_player_hand() {
	is_hand_visible = true
	array_foreach(cards_in_hand, function(_card, _index)
	{
        _card.visible = true
	});
}

/// @desc							Hides all of the cards in the player's hand
function hide_player_hand() {
	is_hand_visible = false
	array_foreach(cards_in_hand, function(_card, _index)
	{
        _card.visible = false
	});
}