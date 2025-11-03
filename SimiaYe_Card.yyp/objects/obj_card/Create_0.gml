card_selected = false
card_start_x_position = x
card_start_y_position = y

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

/// @description							The callback function for obj_target_selection_handler,
///												giving an opertunity for the card to discard the card
function card_has_been_played() {
	discard_card()
}

/// @description							The callback function for obj_target_selection_handler,
///												reseting the card position if playing it was canceled
function reset_card() {
	x = card_start_x_position
	y = card_start_y_position
}