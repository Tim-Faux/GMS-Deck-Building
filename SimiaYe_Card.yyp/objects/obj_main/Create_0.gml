#macro WALK_SPEED 6

event_inherited()

arena = false 

/// @desc							Moves this character on the x axis and checks if moving would cause
///										the character to collide with an obj_wall. If so it sets their
///										x position to that object's edge
/// @param {Real} x_movement		This characters rightward velocity (Negative for leftward movement)
function move_horizontally(x_movement) {
	var collision = instance_place(x + x_movement, y, obj_wall)
	if (collision == noone) {
		x += x_movement;
	}
	else if(x != collision.bbox_right + sprite_xoffset && x != collision.bbox_left - sprite_xoffset) {
		x =  x_movement < 0 ?
				collision.bbox_right + sprite_xoffset :
				collision.bbox_left - sprite_xoffset
	}
}

/// @desc							Moves this character on the y axis and checks if moving would cause
///										the character to collide with an obj_wall. If so it sets their
///										y position to that object's edge
/// @param {Real} y_movement		This characters upward velocity (Negative for downward movement)
function move_vertically(y_movement) {
	var collision = instance_place(x, y + y_movement, obj_wall)
	if (collision == noone) {
		y += y_movement;
	}
	else if(y != collision.bbox_top + sprite_yoffset && y != collision.bbox_bottom - sprite_yoffset) {
		y =  y_movement > 0 ?
				collision.bbox_top - sprite_yoffset :
				collision.bbox_bottom + sprite_yoffset
	}
}