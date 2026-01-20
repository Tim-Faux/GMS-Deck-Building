function struct_card_action(_selected_chara, _selected_cards, _selected_enemies,
							_on_card_action_complete = undefined, _on_card_action_complete_args = []) constructor {
	selected_chara = _selected_chara
	selected_cards = _selected_cards
	selected_enemies = _selected_enemies
	on_card_action_complete = _on_card_action_complete
	on_card_action_complete_args = _on_card_action_complete_args
	
	/// @description								Runs the call back function that allows the card
	///													execution to continue. NOTE: This function
	///													must be run at the end of the card_action
	///													or it will not work correctly
	static end_card_action = function() {
		if(on_card_action_complete != undefined && is_method(on_card_action_complete))
			method_call(on_card_action_complete, on_card_action_complete_args)	
	}
	
	/// @description								Shows the selected cards in a line with a confirmation
	///													button below that destroys the shown cards and
	///													runs the on_card_closed function
	/// @param {String, Id.Layer} layer_id			The layer the cards will be displayed on
	/// @param {function} on_card_closed			The call back function when the card display is closed
	/// @param {Array} on_card_closed_args			The arguments array for on_card_closed
	static show_selected_cards = function(layer_id, on_card_closed, on_card_closed_args) {
		var numCards = array_length(selected_cards)
		if(numCards > 0) {
			var background_dimmer_layer = layer_create(layer_get_depth(layer_id) + 9)
			instance_create_layer(0, 0, background_dimmer_layer, ui_background_dimmer)
			
			create_card_lineup(layer_id)
			
			var confirmation_x = display_get_gui_width() / 2
			var confirmation_y = (display_get_gui_height() + sprite_get_height(object_get_sprite(selected_cards[0])) + 
									sprite_get_height(object_get_sprite(ui_confirm_button)) + 175) / 2
			instance_create_layer(confirmation_x, confirmation_y, layer_id, ui_confirm_button, {
				on_confirm_function : on_card_closed,
				on_confirm_function_args : on_card_closed_args
			})
		}
		else {
			if(on_card_closed != undefined && is_method(on_card_closed))
				method_call(on_card_closed, on_card_closed_args)
			find_and_delete_related_layers(layer_id)
		}
	}
	
	/// @description								Creates a line of evenly spaced display cards
	/// @param {String, Id.Layer} layer_id			The layer the cards will be displayed on
	static create_card_lineup = function(layer_id) {
		var numCards = array_length(selected_cards)
		var card_sprite = object_get_sprite(selected_cards[0])
		var spacing_between_cards = 100 / numCards
		var total_width_of_card_selection = ((sprite_get_width(card_sprite) + spacing_between_cards) * numCards) - spacing_between_cards
		
		var xpos = (display_get_gui_width() - total_width_of_card_selection) / 2
		var ypos = (display_get_gui_height() - sprite_get_height(card_sprite)) / 2
		for (var card_index = 0; card_index < numCards; card_index++) {
			instance_create_layer(xpos, ypos, layer_id, selected_cards[card_index], {
				interaction_type : [card_interaction_type.display_card]
			})
			xpos += sprite_get_width(card_sprite) + spacing_between_cards
		}
	}
	
	/// @description								Loops through each selected character and hit each
	///													selected enemy with their attack multiplied by
	///													attack_multiplier
	/// @param {Real} attack_multiplier				How much each character's attack is muliplied by
	static charas_attack_enemies = function(attack_multiplier) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			activate_on_attack_buffs()
			for (var enemy_index = 0; enemy_index < array_length(selected_enemies); enemy_index++) {
				selected_enemies[enemy_index].hit_by_player(selected_chara[chara_index], attack_multiplier)
			}
		}	
	}
	
	/// @description								Triggers the Gain_Strength_On_Any_Attack effect,
	///													giving the character strength
	static activate_on_attack_buffs = function() {
		for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
			var chara = instance_find(obj_player, chara_index)
			if(chara.active_buffs[$ card_buff_effects.Gain_Strength_On_Any_Attack] != undefined &&
				chara.active_buffs[$ card_buff_effects.Gain_Strength_On_Any_Attack] > 0) {
					chara.apply_buff(card_buff_effects.Strength, 1)
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
			selected_cards[card_index].discard_card()
		}
	}
	
	/// @description								Removes all selected cards from the player's hand and
	///													puts them in the exhaust pile
	static exhaust_selected_cards = function () {
		for (var card_index = 0; card_index < array_length(selected_cards); card_index++) {
			selected_cards[card_index].exhaust_card()
		}
	}
	
	/// @description								Draws cards from the player's deck one at a time and
	///													adds it to their hand
	/// @param {Real} num_card_to_draw				How many cards should be drawn
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
	
	/// @description								Multiplies the player's current energy
	/// @param {Real} mult_amount					The amount the the player's current energy
	///													is being muliplied by
	static mult_energy = function (energy_mult_amount) {
		ui_player_energy.multiply_player_current_energy(energy_mult_amount)
	}
	
	/// @description								Informs the ui_end_turn_button that the player's next
	///													turn is being skipped
	static skip_next_turn = function () {
		ui_end_turn_button.skip_players_next_turn = true
	}
}