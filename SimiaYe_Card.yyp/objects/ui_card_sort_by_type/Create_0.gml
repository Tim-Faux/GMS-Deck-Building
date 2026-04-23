// Inherit the parent event
event_inherited();

/// @desc								Sorts 2 cards by grouping the card types
/// @param {Id.Instance} card1			The card at the lower index
/// @param {Id.Instance} card2			The card at the higher index
/// @returns							Integer that determines the sort order <= -1: card1 goes before card2,
///										0: card1 and card2 are equal price, >= 1: card1 goes after card2
function sort_cards(card1, card2) {
	var card_1_sort_order = determine_sort_order(card1.card_type)
	var card_2_sort_order = determine_sort_order(card2.card_type)
	if (is_sort_ascending) {
		return card_2_sort_order - card_1_sort_order 
	}
	else {
		return card_1_sort_order - card_2_sort_order
	}
}

/// @desc								Finds the order which the card types should be displayed
/// @param {card_type} type_of_card		The card's typing
/// @returns {Real}						The sort order of the given card_type
function determine_sort_order(type_of_card) {
	// NOTE: the higher the number the higher it will appear when is_sort_ascending == true
	switch type_of_card {
		case card_type.ability :
			return 0
		case card_type.attack :
			return 1
		case card_type.none :
			return 2
		default :
			return 3 + card_type
	}
}