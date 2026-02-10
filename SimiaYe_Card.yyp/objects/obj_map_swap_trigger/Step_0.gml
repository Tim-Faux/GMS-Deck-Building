if(!global.room_switching) {
	var chara_in_trigger = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true)
	if(chara_in_trigger != noone && chara_in_trigger.is_controlled_chara) {
		global.room_switching = true
		chara_in_trigger.walk_to_next_room(place_player_dir, sprite_width, method(self, switch_room))
	}
}