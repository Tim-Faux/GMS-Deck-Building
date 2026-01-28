/// @desc							Translates the given debuff into damage taken
/// @param {struct} debuffs			The struct of all the debuff quantities applied to this entity
/// @param {string} debuff_name		The debuff being applied
/// @returns {Array<Any>, Array}	The amount of damage and color of the damage from the debuff. 
///										An empty array if no damage is applied
function get_debuff_damage(debuffs, debuff_name) {
	if(!struct_exists(debuffs, debuff_name)) {
		return []
	}
	else if(debuffs[$ debuff_name] <= 0) {
		struct_remove(debuffs, debuff_name)
		return []
	}
	
	switch (debuff_name) {
		case Card_Debuff_Effects.Poison:
			return [debuffs[$ debuff_name], c_purple]
		case Card_Debuff_Effects.Burn:
			debuffs[$ debuff_name] -= 1
			if(debuffs[$ debuff_name] < 1) {
				struct_remove(debuffs, debuff_name)
				return []
			}
				
			return [debuffs[$ debuff_name], c_red]
		default:
			return [debuffs[$ debuff_name], c_orange]
	}
}

/// @desc							Applies the given debuff_name to the given debuffs
/// @param {struct} debuffs			The struct of all the debuffs applied to this entity
/// @param {string} debuff_name		The debuff being applied
/// @param {Real} debuff_amount		Amount of the debuff being applied (This should be >0)
/// @returns {Array<Any>, Array}	The amount and color of the debuff
function apply_debuff(debuffs, debuff_name, debuff_amount) {
	var debuff_color = c_orange
	
	switch (debuff_name) {
		case Card_Debuff_Effects.Poison:
			debuff_color = c_purple
			break
		case Card_Debuff_Effects.Burn:
			debuff_amount--
			debuff_color = c_red
			break
	}
	
	if(debuff_amount <= 0) {
		return [0, debuff_color]
	}
	else if(struct_exists(debuffs, debuff_name)) {
		debuffs[$ debuff_name] += debuff_amount
	}
	else {
		debuffs[$ debuff_name] = debuff_amount
	}
		
	return [debuff_amount, debuff_color]
}