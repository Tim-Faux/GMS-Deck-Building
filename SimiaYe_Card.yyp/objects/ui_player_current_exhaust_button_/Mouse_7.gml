if(button_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
	var player_current_exhaust_deck = get_player_exhaust_deck()
	var card_display_instance_id = layer_create(depth - 100, "player_exhaust_deck_instance")
	instance_create_layer(x, y, card_display_instance_id, ui_card_grid_display, {
		cards_to_display : player_current_exhaust_deck,
		cards_are_selectable : false,
	})
	
}