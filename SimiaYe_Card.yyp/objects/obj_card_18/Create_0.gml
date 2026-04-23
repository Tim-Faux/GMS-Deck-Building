// Inherit the parent event
event_inherited();

card_description = "For each card drawn this turn gain 1 energy"

/// @desc											Adds 1 energy to the add_energy_on_card_draw which
///														gives the player energy when a card is drawn
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	if(variable_global_exists("add_energy_on_card_draw")) {
		global.add_energy_on_card_draw += 1
	}
	else {
		global.add_energy_on_card_draw = 1	
	}
	card_action_struct.end_card_action()
}