active_debuffs = {}
display_next_damage_text = true
damageToDisplay = []

/// @desc							Handles player attacks by applying debuffs and removing 
///										attack_data.damage from their health
/// @param {Struct} attack_data		The struct containing information about the attack including damage,
///										debuffs, and buffs						
function hit_by_player(attack_data) {
	if(struct_exists(attack_data, "damage")) {
		take_damage(attack_data.damage)
		array_push(damageToDisplay, [attack_data.damage, c_white])
	}
	
	if(struct_exists(attack_data, "debuffs")) {
		for(var attack_debuff_index = 0; attack_debuff_index < array_length(attack_data.debuffs); attack_debuff_index++) {
			var debuff_type = attack_data.debuffs[attack_debuff_index][0]
			var debuff_amount = attack_data.debuffs[attack_debuff_index][1]
			var debuff_damage = apply_debuff(active_debuffs, debuff_type, debuff_amount)
			
			if(array_length(debuff_damage) == 2) {
				array_push(damageToDisplay, debuff_damage)
			}
		}
	}
}

/// @desc							Damages the player by enemy Attack_damage
function attack_player() {
	obj_player.hit_by_enemy(Attack_damage)
}

/// @desc							Loops through the debuffs currently active on this enemy and
///										applys the damage
function trigger_end_of_turn_debuffs() {
	struct_foreach(active_debuffs, function (debuff_name, debuff_amount) {
		var debuff_data = get_debuff_damage(active_debuffs, debuff_name)
		if(array_length(debuff_data) == 2) {
			array_push(damageToDisplay, debuff_data)
			take_damage(debuff_data[0])
		}
	})
}

/// @desc							Removes health from this enemy and checks if they die
/// @param {Real} health_damage		The amount of health to remove from this enemy
function take_damage(health_damage) {
	Health -= health_damage
	if(Health <= 0 && Is_alive) {
		Is_alive = false
		show_debug_message("This enemy is dead")
	}
}