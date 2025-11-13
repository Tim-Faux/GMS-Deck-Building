class = chara_class.damage

/// @desc								Removes health from the player equal to damage_taken and
///											check if player is still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	player_health -= damage_taken
	show_debug_message(player_health)
	if(player_health <= 0)
		show_debug_message("Player is dead")
}

/// @desc								Finds the type and amount of damage/debuffs the character does
///											when they attack
/// @returns							The struct containing the attack data of the character
function get_attack(damage_multiplier) {
	//TODO need to make this the chara's actual attacks
	var hitstrct = {
	damage : 10 * damage_multiplier,
	debuffs : [[card_debuff_effects.Poison, 3 * damage_multiplier],
				[card_debuff_effects.Burn,  5 * damage_multiplier]]
	}
	return hitstrct
}