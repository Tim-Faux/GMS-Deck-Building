visible = false

if(!variable_global_exists("room_switching"))
	global.room_switching = false
	
function switch_room() {
	global.pos_num_to_swap_to = pos_num_to_swap_to
	room_goto(new_room)
	global.room_switching = false
}