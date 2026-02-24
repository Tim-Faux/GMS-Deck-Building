if(!global.room_switching && variable_global_exists("player_chara") && global.player_chara != noone) {
	var chara_in_trigger = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, global.player_chara, false, true)
	if(chara_in_trigger != noone) {
		trigger_activated()
	}
}