if(!global.room_switching) {
	var chara_in_trigger = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, player_chara, false, true)
	if(chara_in_trigger != noone) {
		trigger_activated()
	}
}