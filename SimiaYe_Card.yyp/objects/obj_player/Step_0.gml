
if (!arena) {
	if(is_controlled_chara) {
		if(variable_global_exists("room_switching") && global.room_switching) {
			animate_player_leaving_room()	
		}
		else {
			var x_movement = InputX(INPUT_CLUSTER.NAVIGATION) * WALK_SPEED
			var y_movement = InputY(INPUT_CLUSTER.NAVIGATION) * WALK_SPEED

			character_moving = x_movement != 0 || y_movement != 0
			move_horizontally(x_movement)
			move_vertically(y_movement)

			set_movement_sprite(InputDirection(0, INPUT_CLUSTER.NAVIGATION))
			if(follower != noone && (x_movement != 0 || y_movement != 0)) {
				follower.set_target_pos(x, y, InputDirection(0, INPUT_CLUSTER.NAVIGATION))
			}
		}
	}
	else if (!character_teleporting) {
		chase_target()
		set_movement_sprite(direction)
		if(path_position == 1) {
			character_moving = false
		}
	}
	else if (character_teleporting) {
		var frames_between_subimages = game_get_speed(gamespeed_fps) / sprite_get_speed(teleport_sprite)
		teleport_effect_subimage += 1 / frames_between_subimages
	}
	
}