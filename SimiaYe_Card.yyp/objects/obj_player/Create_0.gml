class = chara_class.damage
chara_shield = 0

/// @desc								Handles the character being hit and check if player is
///											still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	var remaining_damage = damage_sheild(damage_taken)
	player_health -= remaining_damage
	show_debug_message(player_health)
	if(player_health <= 0)
		show_debug_message("Player is dead")
}

/// @desc								Blocks damage equal to the character's shield and if the damage
///											is greater than the shield it returns the remaining damage
/// @param {Real} damage_taken			The amount of damage the player is taking
/// @returns							The remain damage to be dealt, a minimum of 0
function damage_sheild(damage_taken) {
	if (chara_shield >= damage_taken) {
		chara_shield -= damage_taken
		return 0
	}
	damage_taken -= chara_shield
	chara_shield = 0
	return damage_taken
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

/// @desc								Adds the amount of shield provided to the chara's shield
/// @param {Real} shield_amount			The amount of shield being added
function add_sheild(shield_amount) {
	if (shield_amount > 0)
		chara_shield += shield_amount
}