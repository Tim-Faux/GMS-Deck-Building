
if (arena = false) {
	var x_movement = InputX(INPUT_CLUSTER.NAVIGATION) * WALK_SPEED
	var y_movement = InputY(INPUT_CLUSTER.NAVIGATION) * WALK_SPEED

	if(x_movement != 0) {
		move_horizontally(x_movement)
	}
	if(y_movement != 0) {
		move_vertically(y_movement)
	}
	set_movement_sprite(x_movement, y_movement)
}