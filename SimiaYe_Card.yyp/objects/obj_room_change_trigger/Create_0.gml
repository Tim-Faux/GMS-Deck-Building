if(!variable_global_exists("room_switching"))
	global.room_switching = false

player_chara = noone

/// @desc							Finds the current player controlled character and assigns it to
///										player_chara or set it to noone if no player character is found
///										NOTE: This assumes there is only 1 controlled chara and will
///										not search for any more after one is found
function find_player_chara() {
	player_chara = noone
	for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
		var chara = instance_find(obj_player, chara_index)
		if(chara != noone && chara.is_controlled_chara) {
			player_chara = chara
			return
		}
	}
}

/// @desc							Makes the player chara move in the opposite direction of
///										place_player_dir before swapping them to the new room
function trigger_activated() {
	if(player_chara != noone) {
		global.room_switching = true
		player_chara.walk_to_next_room(place_player_dir, sprite_width + player_chara.sprite_width,
											method(self, switch_room), true)
	}
}

/// @desc							Call back function for obj_player.animate_player_leaving_room()
///										to swap to the given new_room
function switch_room() {
	global.pos_num_to_swap_to = pos_num_to_swap_to
	room_goto(new_room)
}