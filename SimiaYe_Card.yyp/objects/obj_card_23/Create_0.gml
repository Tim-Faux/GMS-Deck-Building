// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg per energy you currently have."
/// @desc											A selected chara deal 0.2 dmg per energy currently 
///														avaliable
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	var energy_before_card_played = ui_player_energy.get_player_current_energy() + energy_cost
	card_action_struct.charas_attack_enemies(energy_before_card_played * 0.2)
}