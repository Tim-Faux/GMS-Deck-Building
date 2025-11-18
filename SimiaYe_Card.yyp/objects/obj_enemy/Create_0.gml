active_debuffs = {}
display_next_damage_text = true
damage_to_display = []

/// @desc										Handles player attacks by applying debuffs and removing
///													attack_data.damage from their health
/// @param {Id.Instance} attacking_chara		The character attacking this enemy			
/// @param {Real} damage_multiplyer				The amount that the character's damage will be multiplied by	
function hit_by_player(attacking_chara, damage_multiplyer) {
	var attack_data = attacking_chara.get_attack(damage_multiplyer)
	if(struct_exists(attack_data, "damage")) {
		Health -= attack_data.damage
		array_push(damage_to_display, [attack_data.damage, c_white])
		if(Health <= 0) {
			Is_alive = false
		}
	}
	
	if(struct_exists(attack_data, "debuffs")) {
		for(var attack_debuff_index = 0; attack_debuff_index < array_length(attack_data.debuffs); attack_debuff_index++) {
			var debuff_type = attack_data.debuffs[attack_debuff_index][0]
			var debuff_amount = attack_data.debuffs[attack_debuff_index][1]
			apply_debuffs(debuff_type, debuff_amount)
		}
	}
}

/// @desc										Applies debuffs to this enemy and adds them to the 
///													damage_to_display queue
/// @param {card_debuff_effects} debuff_type	The debuff being applied to this enemy
/// @param {Real} debuff_amount					The amount of the debuff being added
function apply_debuffs(debuff_type, debuff_amount) {
	if(active_debuffs[$ debuff_type] == undefined)
			active_debuffs[$ debuff_type] = debuff_amount
		else
			active_debuffs[$ debuff_type] += debuff_amount
			
		switch (debuff_type) {
			case card_debuff_effects.Poison:
				array_push(damage_to_display, [active_debuffs[$ debuff_type], c_purple])
				break;
			case card_debuff_effects.Burn:
				array_push(damage_to_display, [active_debuffs[$ debuff_type], c_red])
				break;
			case card_debuff_effects.Weakness:
				array_push(damage_to_display, [active_debuffs[$ debuff_type], c_dkgrey])
				break;
			default:
				array_push(damage_to_display, [active_debuffs[$ debuff_type], c_orange])
				break;
		}
}

/// @desc			Damages the player by enemy Attack_damage
function attack_player() {
	obj_player.hit_by_enemy(Attack_damage)
}

/// @desc							Formats a number by removing any trailing 0s or decimals
/// @param {Real} num_to_format		The number to be returned after formatting
/// @returns						A string representation of the given number with trailing 0s and if
///										if needed decimal point removed
function format_display_number(num_to_format) {
	var num_string = string(num_to_format)
	var decimal_pos = string_pos(num_string, ".")
	if(decimal_pos == 0) {
		return num_string
	}
	
	for(var char_index = string_length(num_string); char_index > decimal_pos - 1; char_index--) {
		if(string_ends_with(num_string, "0")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
		}
		else if (string_ends_with(num_string, ".")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
			break;
		}
		else {
			break;	
		}
	}
	if(string_length(num_string) == 0) {
		num_string = "0"
	}
	return num_string
}