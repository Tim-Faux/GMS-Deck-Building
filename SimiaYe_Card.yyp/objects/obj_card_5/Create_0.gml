// Inherit the parent event
event_inherited();

card_description = "Each character gains 1 Shield"

/// @desc											Give all avaliable chara 1 shield
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		selected_chara[chara_index].add_sheild(1)
	}
}