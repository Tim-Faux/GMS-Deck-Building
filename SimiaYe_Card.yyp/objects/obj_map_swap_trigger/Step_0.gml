if(!global.room_switching && collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_gilk, false, true)) {
	global.room_switching = true
	global.pos_num_to_swap_to = pos_num_to_swap_to
	room_goto(new_room)
	global.room_switching = false
}