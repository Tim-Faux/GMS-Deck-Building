if(!variable_global_exists("room_switching"))
	global.room_switching = false

/// @desc							Makes the player chara move in the opposite direction of
///										place_player_dir before swapping them to the new room
function trigger_activated() {
	if(variable_global_exists("player_chara") && global.player_chara != noone) {
		global.room_switching = true
		global.player_chara.walk_to_next_room(place_player_dir, sprite_width + global.player_chara.sprite_width,
											method(self, switch_room), true)
	}
}

/// @desc							Call back function for obj_player.animate_player_leaving_room()
///										to swap to the given new_room
function switch_room() {
	global.pos_num_to_swap_to = pos_num_to_swap_to
	room_goto(new_room)
}