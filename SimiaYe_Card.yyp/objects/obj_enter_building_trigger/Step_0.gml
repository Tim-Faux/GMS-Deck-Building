if(player_in_range && variable_global_exists("player_chara") && global.player_chara != noone) {
	if (InputCheck(INPUT_VERB.INTERACT) && !global.room_switching && global.player_chara.bbox_bottom > bbox_top) {
		trigger_activated()
	}
	if(distance_to_object(global.player_chara) >= MAX_DIST_TO_ENTER_BUILDING) {
		player_in_range = false
	}
}