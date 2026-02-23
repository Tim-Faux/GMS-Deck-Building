if(player_in_range) {
	if (InputCheck(INPUT_VERB.INTERACT) && !global.room_switching) {
		trigger_activated()
	}
	if(player_chara != noone && distance_to_object(player_chara) >= MAX_DIST_TO_ENTER_BUILDING) {
		player_in_range = false
	}
}