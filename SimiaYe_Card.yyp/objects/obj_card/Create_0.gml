#macro NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD "Not enough energy to play this card!"

card_selected = false
card_start_x_position = x
card_start_y_position = y
show_energy_error = false

#region THIS NEED TO BE IMPLEMENTED IN EACH CARD
//Be sure to check the Variable Definitions, there are many variables to manipulate there

/// @description							The unique action of the card when it is played
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index].get_attack())
	}
}
#endregion

/// @description							Checks to see if no other cards are selected then allows this
///												card to be selected
function select_card() {
	if(!card_selected && ui_player_hand.card_can_be_selected && visible && is_top_layer(layer)) {
		card_selected = true
		ui_player_hand.card_can_be_selected = false
		card_start_x_position = x
		card_start_y_position = y
		x = mouse_x - (sprite_width / 2)
		y = mouse_y - (sprite_height / 2)
	}
}

/// @description							Removes this card from the player's hand and destroy it
function discard_card() {
	add_card_to_discard_deck(object_index)
	ui_player_hand.remove_card(id)
	instance_destroy()
}

/// @description							Handles the card being played. Allowing the player to
///												select the attacker and defender of the card
function play_card() {
	if (ui_player_energy.get_player_current_energy() < energy_cost) {
		show_energy_error = true
		alarm_set(0, 4 * 60)
		reset_card()
	}
	else {
		var target_selection_layer = layer_create(depth - 100)
		instance_create_layer(x, y, target_selection_layer, obj_target_selection_handler, 
		{
			num_chara_to_select,
			attacker_selection_type,
			defender_selection_type,
			allowed_classes,
			card_played : id
		})
	}
}

/// @description							Shows the error prompt for when a card is attempted to be
///												played, but the player does not have enough energy
///												NOTE: This can only be called in the draw function
///												otherwise it will not work
function show_not_enough_energy_error() {
	draw_set_colour(not_enough_energy_error_color)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_font(not_enough_energy_error_font)
	var text_x_pos = display_get_gui_width() / 2
	var text_y_pos = display_get_gui_height() / 3
	draw_text(text_x_pos, text_y_pos, NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD)
}

/// @description								The callback function for obj_target_selection_handler,
///													giving an opportunity for the card to discard the card
/// @param {Array<Id.Instance>} selected_chara	The character(s) selected to for the card's action
/// @param {Id.Instance} enemy_instance			The enemy selected to take damage
function card_has_been_played(selected_chara, enemy_instance) {
	ui_player_energy.remove_from_player_current_energy(energy_cost)
	card_action(selected_chara, enemy_instance)
	discard_card()
}

/// @description							The callback function for obj_target_selection_handler,
///												reseting the card position if playing it was canceled
function reset_card() {
	x = card_start_x_position
	y = card_start_y_position
}