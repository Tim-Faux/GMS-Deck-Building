// Inherit the parent event
event_inherited();

card_description = "Doubles the character's Strength."
/// @desc											Multiplies a selected chara's Strength by 2
/// @param {Array<Id.Instance>} selected_chara		The character(s) selected to for the card's action
/// @param {Array<Id.Instance>} enemy_instances		The enemy(s) selected to take damage
card_action = function (selected_chara, enemy_instances) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			selected_chara[chara_index].multiply_buff(card_buff_effects.Strength, 2)
	}
}