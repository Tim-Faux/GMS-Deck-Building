#macro WALK_SPEED 6

move_north_west_sprite =	noone
move_north_sprite =			noone
move_north_east_sprite =	noone
move_east_sprite =			noone
move_south_east_sprite =	noone
move_south_sprite =			noone
move_south_west_sprite =	noone
move_west_sprite =			noone

stand_still_sprite =		noone
arena = false

/// @desc								Removes health from the player equal to damage_taken and
///											check if player is still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	player_health -= damage_taken
	show_debug_message(player_health)
	if(player_health <= 0)
		show_debug_message("Player is dead")
}

/// @desc							Moves this character on the x axis and checks if moving would cause
///										the character to collide with an obj_wall. If so it sets their
///										x position to that object's edge
/// @param {Real} x_movement		This characters rightward velocity (Negative for leftward movement)
function move_horizontally(x_movement) {
	var collision = instance_place(x + x_movement, y, obj_wall)
	if (collision == noone) {
		x += x_movement
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
		y += y_movement
	}
	else if(y != collision.bbox_top + sprite_yoffset && y != collision.bbox_bottom - sprite_yoffset) {
		y =  y_movement > 0 ?
				collision.bbox_top - sprite_yoffset :
				collision.bbox_bottom + sprite_yoffset
	}
}

/// @desc							Updates the character's sprite based on their movement direction
/// @param {Real} x_movement		This characters rightward velocity (Negative for leftward movement)
/// @param {Real} y_movement		This characters upward velocity (Negative for downward movement)
function set_movement_sprite(x_movement, y_movement) {
	var y_sprite_index = y_movement == 0 ?
							1 :
							1 + (y_movement / abs(y_movement))
	var x_sprite_index = x_movement == 0 ? 
							1 :
							1 + (x_movement / abs(x_movement))
	var movement_sprites = get_movement_sprites_array()
	sprite_index = movement_sprites[y_sprite_index][x_sprite_index]
	var temp = spr_gilk_walkleft
}

/// @desc									Creates a 2D array with all of the charater's movement 
///												sprites where the first index is the vertical direction
///												and the second index is the horizontal direction
/// @returns {Array<Array<Asset.GMSprite>>}	The array of movement sprites
function get_movement_sprites_array() {
	return [[move_north_west_sprite,	move_north_sprite,	move_north_east_sprite],
			[move_west_sprite,			stand_still_sprite,	move_east_sprite],
			[move_south_west_sprite,	move_south_sprite,	move_south_east_sprite]]
	//[[move_south_west_sprite,	move_west_sprite,	move_north_west_sprite],
	//		[move_north_sprite,			stand_still_sprite,	move_south_sprite],
	//		[move_south_east_sprite,	move_east_sprite,	move_north_east_sprite]]
}