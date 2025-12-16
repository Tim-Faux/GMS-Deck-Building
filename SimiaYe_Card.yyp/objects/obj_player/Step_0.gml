
if (!arena) {
	if(is_controlled_chara) {
		var x_movement = InputX(INPUT_CLUSTER.NAVIGATION) * WALK_SPEED
		var y_movement = InputY(INPUT_CLUSTER.NAVIGATION) * WALK_SPEED
		

		if(x_movement != 0) {
			move_horizontally(x_movement)
		}
		if(y_movement != 0) {
			move_vertically(y_movement)
		}
		set_movement_sprite(x_movement, y_movement)
		if(follower != noone && (x_movement != 0 || y_movement != 0)) {
			follower.set_target_pos(x, y, InputDirection(0, INPUT_CLUSTER.NAVIGATION))	
		}
	}
	else if (!character_teleporting) {
		chase_target()
	}
	
}