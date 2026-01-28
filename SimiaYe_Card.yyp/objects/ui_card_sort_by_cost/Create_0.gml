// Inherit the parent event
event_inherited();

/// @desc								Sorts 2 cards by determining which costs more
/// @param {Id.Instance} card1			The card at the lower index
/// @param {Id.Instance} card2			The card at the higher index
/// @returns							Integer that determines the sort order (<= -1: card1 goes before card2,
///										0: card1 and card2 are equal price, >= 1: card1 goes after card2
function sort_cards(card1, card2) {
	if (is_sort_ascending) {
		return card2.energy_cost - card1.energy_cost 
	}
	else {
		return card1.energy_cost - card2.energy_cost 
	}
}