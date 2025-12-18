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
teleport_sprite =			noone

arena = false
target_pos = new character_position_target(x, y, 0, sprite_width, sprite_height)
path = path_add()
character_teleporting = false
set_follow_target()

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
///										the character to collide with an obj_wall. If so it moves this
///										character to the edge of that wall
/// @param {Real} x_movement		This characters rightward velocity (Negative for leftward movement)
function move_horizontally(x_movement) {
	for(var x_step = abs(x_movement); x_step > 0; x_step--) {
		var signed_x_step = x_movement < 0 ? -x_step : x_step
		var collision = instance_place(x + signed_x_step, y, obj_wall)
		if (collision == noone) {
			x += signed_x_step
			break
		}
	}
}

/// @desc							Moves this character on the y axis and checks if moving would cause
///										the character to collide with an obj_wall. If so it moves this
///										character to the edge of that wall
/// @param {Real} y_movement		This characters upward velocity (Negative for downward movement)
function move_vertically(y_movement) {
	for(var y_step = abs(y_movement); y_step > 0; y_step--) {
		var signed_y_step = y_movement < 0 ? -y_step : y_step
		var collision = instance_place(x, y + signed_y_step, obj_wall)
		if (collision == noone) {
			y += signed_y_step
			break
		}
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
}

/// @desc									Creates a 2D array with all of the charater's movement 
///												sprites where the first index is the vertical direction
///												and the second index is the horizontal direction
/// @returns {Array<Array<Asset.GMSprite>>}	The array of movement sprites
function get_movement_sprites_array() {
	return [[move_north_west_sprite,	move_north_sprite,	move_north_east_sprite],
			[move_west_sprite,			stand_still_sprite,	move_east_sprite],
			[move_south_west_sprite,	move_south_sprite,	move_south_east_sprite]]
}

/// @desc							Finds the an avaliable obj_player to follow
function set_follow_target() {
	if(!is_controlled_chara) {
		for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
			var chara_to_follow = instance_find(obj_player, chara_index)
			if(chara_to_follow != id && chara_to_follow != noone && chara_to_follow.follower == noone) {
				chara_to_follow.follower = id
				set_target_pos(chara_to_follow.x, chara_to_follow.y, 270)
				break
			}
		}
	}
}

/// @desc							The struct defining the position information needed for allies to
///										follow the player
/// @param {Real} _x_intent			The x position of the character that this character is following
/// @param {Real} _y_intent			The y position of the character that this character is following
/// @param {Real} _angle			The angle in degrees around the targeted position for this character
///										to align itself to
/// @param {Real} _sprite_width		The width of this character's sprite
/// @param {Real} _sprite_height	The height of this character's sprite
function character_position_target(_x_intent, _y_intent, _angle, _sprite_width, _sprite_height) constructor {
	#macro SPACE_BETWEEN_FOLLOWERS 5
	x_intent = _x_intent
	y_intent = _y_intent
	angle = _angle
	sprite_width = _sprite_width
	sprite_height = _sprite_height
	x = x_intent - ((_sprite_width + SPACE_BETWEEN_FOLLOWERS) * dcos(_angle))
	y = y_intent + ((_sprite_height + SPACE_BETWEEN_FOLLOWERS) * dsin(_angle))
		
	/// @desc							Used to redefine this structs variables
	/// @param {Real} _x_intent			The x position of the character that this character is following
	/// @param {Real} _y_intent			The y position of the character that this character is following
	/// @param {Real} _angle			The angle in degrees around the targeted position for this character
	///										to align itself to
	/// @param {Real} _sprite_width		The width of this character's sprite
	/// @param {Real} _sprite_height	The height of this character's sprite
	static update_target_pos = function(_x_intent, _y_intent, _angle, _sprite_width, _sprite_height) {
		x_intent = _x_intent
		y_intent = _y_intent
		angle = _angle
		sprite_width = _sprite_width
		sprite_height = _sprite_height
		x = x_intent - ((_sprite_width + SPACE_BETWEEN_FOLLOWERS) * dcos(_angle))
		y = y_intent + ((_sprite_height + SPACE_BETWEEN_FOLLOWERS) * dsin(_angle))
	}
	
	/// @desc							Attempts to find a space this character fits by shifting them
	///										horizontally and vertically outside of the collision box
	/// @param {Id.Instance} collision	The object this character collided with when attempting to place
	///										their target position
	/// @param {Real} _sprite_width		Width of this character's current sprite. Defaults to the struct's
	///										current sprite_width
	/// @param {Real} _sprite_height	Height of this character's current sprite. Defaults to the struct's
	///										current sprite_height
	static find_open_space = function(collision, _sprite_width = sprite_width, _sprite_height = sprite_height) {
		sprite_width = _sprite_width
		sprite_height = _sprite_height
		if(abs(dcos(angle)) >= abs(dsin(angle))) {
			shift_on_x(collision)
		}
		else {
			shift_on_y(collision)
		}	
	}
	
	/// @desc								Attempts to shift this character horizontally to the edge of the
	///											collision box so long as it doesnt pass the x_intent
	/// @param {Id.Instance} collision		The object this character collided with when attempting to place
	///											their target position
	/// @param {bool} shift_y_attempted		Optional flag to determine if shifting y should be attempted if
	///											shifting x fails
	static shift_on_x = function(collision, shift_y_attempted = false) {
		if(collision.bbox_right < x_intent) {
			x = collision.bbox_right + (sprite_width / 2)
		}
		else if(collision.bbox_left > x_intent) {
			x = collision.bbox_left - (sprite_width / 2)
		}
		else if(!shift_y_attempted) {
			shift_on_y(collision, true)
		}
		else {
			x = x_intent
			y = y_intent
		}
	}
	
	/// @desc								Attempts to shift this character vertically to the edge of the
	///											collision box so long as it doesnt pass the y_intent
	/// @param {Id.Instance} collision		The object this character collided with when attempting to place
	///											their target position
	/// @param {bool} shift_x_attempted		Optional flag to determine if shifting x should be attempted if
	///											shifting y fails
	static shift_on_y = function(collision, shift_x_attempted = false) {
		if(collision.bbox_bottom < y_intent) {
			y = collision.bbox_bottom + (sprite_height / 2)
		}
		else if(collision.bbox_top > y_intent) {
			y = collision.bbox_top - (sprite_height / 2)
		}
		else if(!shift_x_attempted) {
			shift_on_x(collision, true)
		}
		else {
			x = x_intent
			y = y_intent
		}
	}
}

/// @desc							Repeatedly attempts to shift this character's target position until
///										it is out of any collision objects
/// @param {Real} leader_x			The x position of the character that this character is following
/// @param {Real} leader_y			The y position of the character that this character is following
/// @param {Real} angle				The angle in degrees around the targeted position for this character
///										to align itself to
function set_target_pos(leader_x, leader_y, angle) {
	target_pos.update_target_pos(leader_x, leader_y, angle, sprite_height, sprite_width)
	var num_open_space_attempts = 0
	while(true) {
		var collision = collision_rectangle(target_pos.x - sprite_xoffset, target_pos.y - sprite_yoffset,
											target_pos.x + sprite_xoffset, target_pos.y + sprite_yoffset,
											obj_brick, false, false)
		if(collision != noone && num_open_space_attempts < 10) {
			target_pos.find_open_space(collision, sprite_width, sprite_height)
		}
		else {
			if(follower != noone) {
				follower.set_target_pos(target_pos.x, target_pos.y, target_pos.angle)
			}
			break
		}
		num_open_space_attempts++
	}
}

/// @desc							Moves this character towards its target_pos, avoiding obstacles,
///										so long as it's not controlled by the player. If no path can
///										be found it is teleported to the target_pos
function chase_target() {
	var dist_move_speed_modifier = (sqr(target_pos.x - x) + sqr(target_pos.y - y))
									/ sqr(sprite_width / 2)
	var move_speed = clamp(WALK_SPEED + dist_move_speed_modifier, WALK_SPEED, WALK_SPEED * 2)

	mp_potential_settings(180, 30, 1, false)
	if(mp_potential_path_object(path, target_pos.x, target_pos.y, move_speed, 4, obj_brick)) {
		path_start(path, move_speed, path_action_stop, false)
		if(follower != noone) {
			follower.set_target_pos(x, y, target_pos.angle)
		}
	}
	else {
		teleport_character()
	}
}

/// @desc							Plays an animation and teleports this player to either the given
///										position or this character's target_pos
/// @param {Real} teleport_pos_x	Optional x coordinate to teleport to
/// @param {Real} teleport_pos_y	Optional y coordinate to teleport to
function teleport_character(teleport_pos_x = target_pos.x, teleport_pos_y = target_pos.y) {
	if(follower != noone) {
		follower.set_target_pos(teleport_pos_x, teleport_pos_y, target_pos.angle)
	}
	sprite_index = teleport_sprite
	character_teleporting = true
}