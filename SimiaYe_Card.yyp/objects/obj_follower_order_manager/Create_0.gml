if(instance_number(obj_follower_order_manager) > 1) {
	instance_destroy()
}
if(!variable_global_exists("player_chara")) {
	global.player_chara = noone
}

if(!variable_global_exists("followers_being_added")) {
	global.followers_being_added = false
}

followers_to_add = ds_queue_create()
room_has_started = false

/// @desc							Finds the current player controlled character and assigns it to
///										player_chara or set it to noone if no player character is found
///										NOTE: This assumes there is only 1 controlled chara and will
///										not search for any more after one is found
function find_player_chara() {
	global.player_chara = noone
	for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
		var chara = instance_find(obj_player, chara_index)
		if(chara != noone && chara.is_controlled_chara) {
			global.player_chara = chara
			return
		}
	}
}

/// @desc								Adds a given follower to the followers_to_add queue
///											NOTE: This is the method that should be used when an npc
///											character is created that will follow the player
/// @param {Id.Instance} chara_to_add	The character to be added to the follower chain
function add_follower(chara_to_add) {
	ds_queue_enqueue(followers_to_add, chara_to_add)
	
	if(room_has_started)
		add_queue_to_follower_chain()
}

/// @desc								Continually loops through the followers_to_add queue and
///											attempts to place the characters at the end of the
///											follower chain
function add_queue_to_follower_chain() {
	if(!variable_global_exists("followers_being_added") || !global.followers_being_added) {
		global.followers_being_added = true
		while(ds_queue_size(followers_to_add) > 0) {
			if(!variable_global_exists("player_chara") || global.player_chara == noone) {
				var player_chara_found = find_player_chara()
				if(!player_chara_found) {
					break	
				}
			}
			else {
				add_chara_to_follower_chain_end(global.player_chara, ds_queue_dequeue(followers_to_add))
			}
		}
		global.followers_being_added = false
	}
}

/// @desc								Adds the given character to the end of the leader_chara's
///											follower chain
/// @param {Id.Instance} leader_chara	A participent in the character chain to add a character to.
///											NOTE: This can be any character in the chain as it will
///											loop to the end of the chain to add the new character
/// @param {Id.Instance} chara_to_add	The character instance to add to the end of the chain
function add_chara_to_follower_chain_end(leader_chara, chara_to_add) {
	if(leader_chara != noone && leader_chara.follower == noone) {
		leader_chara.follower = chara_to_add
		return true
	}
	else if(leader_chara == chara_to_add) {
		return false
	}
	else {
		return add_chara_to_follower_chain_end(leader_chara.follower, chara_to_add)	
	}
}

/// @desc								Adds a given character chain as a follower of the given
///											character, pushing the leader's chain to the end of
///											chara_to_add's chain
/// @param {Id.Instance} leader_chara	The character instance to set the follower of
/// @param {Id.Instance} chara_to_add	The character instance to set as leader_chara's follower
function add_follower_chain_to_leader(leader_chara, chara_to_add) {
	if(leader_chara.follower != noone) {
		var temp = leader_chara.follower
		leader_chara.follower = chara_to_add
		add_chara_to_follower_chain_end(chara_to_add, temp)
	}
	else {
		leader_chara.follower = chara_to_add
	}
}