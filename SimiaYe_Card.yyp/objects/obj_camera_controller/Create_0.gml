#macro CAMERA_EASING	0.15

main_camera = view_camera[0]
camera_width = camera_get_view_width(main_camera)
camera_height = camera_get_view_height(main_camera)

/// @desc						Sets the initial position of the camera so it starts on the player character
function set_camera_initial_pos() {
	var target = camera_get_view_target(main_camera)
	var new_camera_x = clamp(target.x - (camera_width / 2), 0, room_width - camera_width)
	var new_camera_y = clamp(target.y - (camera_height / 2), 0, room_height - camera_height)
	camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
}

/// @desc						Sets the camera to be closer to the target using an asymptotic averaging
///									function. NOTE: This should be run every frame for smooth movement
function set_camera_pos() {
	var target = camera_get_view_target(main_camera)
	var target_camera_x = target.x - (camera_width / 2)
	var target_camera_y = target.y - (camera_height / 2)
	var camera_x_movement = CAMERA_EASING * (target_camera_x - camera_get_view_x(main_camera))
	var camera_y_movement = CAMERA_EASING * (target_camera_y - camera_get_view_y(main_camera))
	var new_camera_x = clamp(camera_get_view_x(main_camera) + camera_x_movement, 0, room_width - camera_width)
	var new_camera_y = clamp(camera_get_view_y(main_camera) + camera_y_movement, 0, room_height - camera_height)
	camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
}