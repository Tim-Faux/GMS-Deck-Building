if(button_clicked && room_exists(new_room) && is_top_layer(layer)) {
	button_clicked = false
	global.object_being_clicked = false
	reset_player_current_deck()
	reset_player_discard_deck()
	room_goto(new_room)
}