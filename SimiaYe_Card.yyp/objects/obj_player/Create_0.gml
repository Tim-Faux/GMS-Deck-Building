#macro TIME_BETWEEN_EFFECT_TEXT 12
#macro MAX_CHARA_SHIELD 5

class = chara_class.damage
active_buffs = {}
display_next_effect_text = true
effect_to_display = []
chara_shield = 0
player_current_health = player_max_health

/// @desc								Handles the character being hit and check if player is
///											still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	damage_taken = clamp(damage_taken - chara_shield, 0, damage_taken)
	player_current_health = clamp(player_current_health - damage_taken, 0, player_max_health)
	show_debug_message(player_current_health)
	if(player_current_health <= 0)
		show_debug_message("Player is dead")
}

/// @desc								Displays the damage, buffs, and debuffs applied to the chara, 
///											allowing for different quantity and color to differentiate
///											the source of the text
function display_effect_text() {
	if(display_next_effect_text) {
		if(array_length(effect_to_display) > 0) {
			var damage_data = array_shift(effect_to_display)
			var amount_of_damage = format_display_number(damage_data[0])
			var damage_text_color = damage_data[1]
			instance_create_layer(x, y, "Instances", obj_damageText,
			{
				damage_taken : amount_of_damage,
				text_color : damage_text_color
			})
			alarm[0] = TIME_BETWEEN_EFFECT_TEXT
			display_next_effect_text = false
		}
	}
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

/// @desc								Finds the type and amount of damage/debuffs the character does
///											when they attack
/// @returns							The struct containing the attack data of the character
function get_attack(damage_multiplier) {
	//TODO need to make this the chara's actual attacks
	var strength = 0
	if(active_buffs[$ card_buff_effects.Strength] != undefined)
		strength = active_buffs[$ card_buff_effects.Strength]
		
	var hitstrct = {
	damage : (10 + strength) * damage_multiplier,
	debuffs : [[card_debuff_effects.Poison, 3 * damage_multiplier],
				[card_debuff_effects.Burn,  5 * damage_multiplier]]
	}
	return hitstrct
}

/// @desc								Adds the amount of shield provided to the chara's shield
/// @param {Real} shield_amount			The amount of shield being added
function add_sheild(shield_amount) {
	if (shield_amount > 0)
		chara_shield = clamp(chara_shield + shield_amount, 0, MAX_CHARA_SHIELD)
}

/// @desc								Heals the chara by the given amount up, but not more than,
///											their max health
/// @param {Real} health_to_add			The maximum health to be healed
function heal_chara(health_to_add) {
	if(health_to_add > 0)
		player_current_health = clamp(player_current_health + health_to_add, 0, player_max_health)
}

/// @desc										Applies a buff to this chara and adds them to the 
///													effect_to_display queue
/// @param {card_buff_effects} buff_type		The buff being applied
/// @param {Real} buff_amount					The amount of the buff being added
function apply_buff(buff_type, buff_amount) {
	if(active_buffs[$ buff_type] == undefined)
			active_buffs[$ buff_type] = buff_amount
	else
		active_buffs[$ buff_type] += buff_amount
			
	switch (buff_type) {
		case card_buff_effects.Strength:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_maroon])
			break;
	}
}

/// @desc										Increases the amount of a given buff by multiplying it
///													by amount_multipled and adds them to the 
///													effect_to_display queue
/// @param {card_buff_effects} buff_type		The buff being modified
/// @param {Real} buff_amount					The amount of the buff being added
function multiply_buff(buff_type, amount_multiplied) {
	if(active_buffs[$ buff_type] != undefined) {
			active_buffs[$ buff_type] *= amount_multiplied
	}
			
	switch (buff_type) {
		case card_buff_effects.Strength:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_maroon])
			break;
	}
}