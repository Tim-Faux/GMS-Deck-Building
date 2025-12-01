function struct_card_action(_selected_chara, _selected_cards, _selected_enemies) constructor {
	selected_chara = _selected_chara
	selected_cards = _selected_cards
	selected_enemies = _selected_enemies
	
	/// @description								Loops through each selected character and hit each
	///													selected enemy with their attack multiplied by
	///													attack_multiplier
	/// @param {Real} attack_multiplier				How much each character's attack is muliplied by
	static charas_attack_enemies = function(attack_multiplier) {
		for (var enemy_index = 0; enemy_index < array_length(selected_enemies); enemy_index++) {
			for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
				selected_enemies[enemy_index].hit_by_player(selected_chara[chara_index], attack_multiplier)
			}
		}	
	}
	
	/// @description								Loops through each selected character and hit each
	///													selected enemy with their attack multiplied by
	///													the amount of shield that character has
	static deal_dmg_to_enemies_equal_to_shield = function() {
		for (var enemy_index = 0; enemy_index < array_length(selected_enemies); enemy_index++) {
			for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
				selected_enemies[enemy_index].hit_by_player(selected_chara[chara_index], selected_chara[chara_index].chara_shield)
			}
		}
	}
	
	/// @description								Applies a given debuff to all selected enemies
	/// @param {card_debuff_effects} debuff_type	The debuff being applied to this enemy
	/// @param {Real} debuff_amount					The amount of the debuff being added
	static apply_debuff_to_enemies = function(debuff_type, debuff_amount) {
		for (var enemy_index = 0; enemy_index < array_length(selected_enemies); enemy_index++) {
			selected_enemies[enemy_index].apply_debuff_to_enemy(debuff_type, debuff_amount)
		}	
	}
	
	/// @description								Applies shield to all selected characters
	/// @param {Real} shield_amount					The amount of shield each character gets
	static charas_gain_shield = function(shield_amount) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			selected_chara[chara_index].add_shield(shield_amount)
		}
	}
	
	/// @description								Heals all selected charactes
	/// @param {Real} heal_amount					The amount of health each character heals
	static charas_heal = function(heal_amount) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			selected_chara[chara_index].heal_chara(heal_amount)
		}
	}
	
	/// @description								Applies a given buff to all selected characters
	/// @param {card_buff_effects} buff_type		The buff being applied
	/// @param {Real} buff_amount					The amount of the buff being added
	static add_buff_to_charas = function (buff_type, buff_amount) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			selected_chara[chara_index].apply_buff(buff_type, buff_amount)
		}	
	}
	
	/// @description								Multiplies the given buff by mult_amount for 
	///													each selected character
	/// @param {card_buff_effects} buff_type		The buff being multiplied
	/// @param {Real} mult_amount					The amount the buff is being multiplied by
	static mult_charas_buff = function (buff_type, mult_amount) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			selected_chara[chara_index].multiply_buff(buff_type, mult_amount)
		}	
	}
	
	/// @description								Removes all selected cards from the player's hand and
	///													puts them in the discard pile
	static discard_selected_cards = function () {
		for (var card_index = 0; card_index < array_length(selected_cards); card_index++) {
			add_card_to_discard_deck(selected_cards[card_index].object_index)
			ui_player_hand.remove_card(selected_cards[card_index])
		}
	}
	
	/// @description								Draws cards from the player's deck one at a time and
	///													adds it to their hand
	static draw_num_cards = function(num_card_to_draw) {
		repeat (num_card_to_draw) {
			var drawn_card = draw_card()
			if(drawn_card != -1) {
				var add_card_succeeded = ui_player_hand.add_card(drawn_card)
				if(!add_card_succeeded) {
					break	
				}
			}
		}
	}
	
	/// @description								Adds a given amount of energy to the player's current
	///													energy pool
	/// @param {Real} mult_amount					The amount of energy added to the player's energy pool
	static add_energy = function (energy_amount) {
		ui_player_energy.add_to_player_current_energy(energy_amount)
	}
}