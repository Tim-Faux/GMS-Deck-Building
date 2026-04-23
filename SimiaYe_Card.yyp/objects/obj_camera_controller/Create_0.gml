#macro CAMERA_EASING	0.15

main_camera = view_camera[0]
camera_width = camera_get_view_width(main_camera)
camera_height = camera_get_view_height(main_camera)
follow_target = noone

/// @desc						Sets the initial position of the camera so it starts on the player character
function set_camera_initial_pos() {
	find_follow_target()
	var new_camera_x = clamp(follow_target.x - (camera_width / 2), 0, room_width - camera_width)
	var new_camera_y = clamp(follow_target.y - (camera_height / 2), 0, room_height - camera_height)
	camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
}

/// @desc						Sets the camera to be closer to the target using an asymptotic averaging
///									function. NOTE: This should be run every frame for smooth movement
function set_camera_pos() {
	if(follow_target == noone) {
		find_follow_target()	
	}
	else {
		var target_camera_x = follow_target.x - (camera_width / 2)
		var target_camera_y = follow_target.y - (camera_height / 2)
		var camera_x_movement = CAMERA_EASING * (target_camera_x - camera_get_view_x(main_camera))
		var camera_y_movement = CAMERA_EASING * (target_camera_y - camera_get_view_y(main_camera))
		var new_camera_x = clamp(camera_get_view_x(main_camera) + camera_x_movement, 0, room_width - camera_width)
		var new_camera_y = clamp(camera_get_view_y(main_camera) + camera_y_movement, 0, room_height - camera_height)
		camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
	}
}

/// @desc						Finds a player controlled character and sets it as the camera's
///									follow target
function find_follow_target() {
	if(variable_global_exists("player_chara") && global.player_chara != noone) {
		if(!instance_exists(global.player_chara)) {
			return
		}
		if(instance_number(global.player_chara.object_index) == 1) {
			follow_target = global.player_chara
		}
		else {
			for(var player_chara_index = 0; player_chara_index < instance_number(global.player_chara.object_index); player_chara_index++) {
				var chara_instance = instance_find(global.player_chara.object_index, player_chara_index)
				if(chara_instance != noone && chara_instance.is_controlled_chara) {
					follow_target = chara_instance
				}
			}
		}
	}
	else {
		for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
			var chara = instance_find(obj_player, chara_index)
			if(chara != noone && chara.is_controlled_chara) {
				follow_target = chara
				break
			}
		}
	}
	
	camera_set_view_target(main_camera, follow_target)
}