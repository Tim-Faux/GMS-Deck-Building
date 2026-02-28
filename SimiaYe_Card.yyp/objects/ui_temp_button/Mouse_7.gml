if(is_top_layer(layer, mouse_x, mouse_y)) {
	if(!instance_exists(ui_player_hand)) {
		instance_create_layer(x,y,"Instances",ui_player_hand)
	}
	else if (ui_player_hand.is_hand_visible) {
		ui_player_hand.hide_player_hand()
	}
	else {
		ui_player_hand.show_player_hand()
	}
}