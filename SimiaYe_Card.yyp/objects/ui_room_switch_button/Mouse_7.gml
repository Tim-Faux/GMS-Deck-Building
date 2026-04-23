if(button_clicked && room_exists(new_room) && is_top_layer(layer, mouse_x, mouse_y)) {
	button_clicked = false
	global.object_being_clicked = false
	reset_player_current_deck()
	reset_player_discard_deck()
	reset_player_exhaust_deck()
	room_goto(new_room)
}