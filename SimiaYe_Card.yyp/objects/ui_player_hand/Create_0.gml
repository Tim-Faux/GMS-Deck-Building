#macro SPACE_BETWEEN_CARDS_IN_HAND 1

cards_in_hand = array_create(0)
is_hand_visible = true
total_width_of_hand = 0

add_multiple_cards(get_player_current_deck())

/// @desc							Finds all the cards in the player's current hand
/// @returns						An array of the cards currently in the player's hand
function get_player_current_hand() {
	return cards_in_hand
}

/// @desc							Adds a specified card to the player's hand and shows it in the UI
/// @param {Asset.GMObject} card	The card that is being added to the player's hand
function add_card(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card)
	array_push(cards_in_hand, card_instance)
	
	position_cards_in_hand()
}

/// @desc							Adds multiple specified cards to the player's hand 
///										and shows it in the UI
/// @param {Array} cards			The cards that are being added to the player's hand
function add_multiple_cards(cards) {
	var current_num_cards_in_hand = array_length(cards_in_hand)
	var new_array_length = current_num_cards_in_hand + array_length(cards)
	array_resize(cards_in_hand, new_array_length)
	for(var card_index = current_num_cards_in_hand; card_index < new_array_length; card_index++) {
		var card_instance = instance_create_layer(x, y, "Instances", cards[card_index])
		cards_in_hand[card_index] = card_instance
	}
	position_cards_in_hand()
}

/// @desc							Removes the given card from the players hand if it exists
/// @param {Id.Instance} card		The card that is being removed from the player's hand
function remove_card(card) {
	for(var card_index = 0; card_index < array_length(cards_in_hand); card_index++) {
		if (cards_in_hand[card_index].id == card.id) {
			array_delete(cards_in_hand, card_index, 1)
			position_cards_in_hand()
			break
		}
	}
}

/// @desc							Sets the x and y position of all the cards in cards_in_hand
function position_cards_in_hand() {
	get_hand_display_variables()
	var next_card_x = (display_get_gui_width() - total_width_of_hand) / 2
	for(var card_index = 0; card_index < array_length(cards_in_hand); card_index++) {
		if(cards_in_hand[card_index] != 0) {
			cards_in_hand[card_index].x = next_card_x
			cards_in_hand[card_index].y = display_get_gui_height() - cards_in_hand[card_index].sprite_height
			next_card_x += cards_in_hand[card_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		}
	}
}

/// @desc							Loop through the player's hand to find the data needed to display 
///										the cards while ensuring the list of cards is totally clean
function get_hand_display_variables() {
	total_width_of_hand = 0
	
	for(var hand_index = 0; hand_index < array_length(cards_in_hand); hand_index++) {
		if(cards_in_hand[hand_index] != 0) {
			total_width_of_hand += cards_in_hand[hand_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		}
		else {
			array_delete(cards_in_hand, hand_index, 1)
			hand_index--
		}
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