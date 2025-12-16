#macro WALK_SPEED 6
#macro SPACE_BETWEEN_FOLLOWERS 5

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
// @desc	The array determining the x, y, and angle around their target this character wants to path to
target_pos = [0, 0, 90]
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

/// @desc							Attempts to find an open place for this character to path towards,
///										while moving the target_pos out of any collision objects
/// @param {Real} x_intent			The x coordinate this character paths towards
/// @param {Real} y_intent			The y coordinate this character paths towards
/// @param {Real} angle				The angle in degrees around the targeted position for this character
///										to align to
/// @param {Bool} add_x_spacing		Determines if this character should automatically add space between
///										the x_intent and its final position. Defaults to true
/// @param {Bool} add_y_spacing		Determines if this character should automatically add space between
///										the y_intent and its final position. Defaults to true
function set_target_pos(x_intent, y_intent, angle, add_x_spacing = true, add_y_spacing = true) {
	var x_goal = x_intent
	var y_goal = y_intent
	if(add_x_spacing)
		x_goal -= ((sprite_width + SPACE_BETWEEN_FOLLOWERS) * dcos(angle))
	if(add_y_spacing)
		y_goal += ((sprite_height + SPACE_BETWEEN_FOLLOWERS) * dsin(angle))
	
	var collision = collision_rectangle(x_goal - sprite_xoffset, y_goal - sprite_yoffset,
										x_goal + sprite_xoffset, y_goal + sprite_yoffset,
										obj_brick, false, false)
	if(collision != noone) {
		if(x_intent > x_goal && collision.bbox_right <= x_intent) {
			//Move to right of collision's hitbox
			x_goal = collision.bbox_right + (sprite_width / 2)
			set_target_pos(x_goal, y_intent, angle, false, true)
		}
		else if(x_intent < x_goal && collision.bbox_left >= x_intent) {
			//Move to left of collision's hitbox
			x_goal = collision.bbox_left - (sprite_width / 2)
			set_target_pos(x_goal, y_intent, angle, false, true)
		}
		else if(y_intent > y_goal && collision.bbox_bottom <= y_intent) {
			//Move to bottom of collision's hitbox
			y_goal = collision.bbox_bottom + (sprite_height / 2)
			set_target_pos(x_goal, y_goal, angle, false, false)
		}
		else if(y_intent < y_goal && collision.bbox_top >= y_intent) {
			//Move to top of collision's hitbox
			y_goal = collision.bbox_top - (sprite_height / 2)
			set_target_pos(x_goal, y_goal, angle, false, false)
		}
		else {
			target_pos[0] = x_goal
			target_pos[1] = y_goal
			target_pos[2] = angle
		}
	}
	else {
		target_pos[0] = x_goal
		target_pos[1] = y_goal
		target_pos[2] = angle
	}
}

/// @desc							Moves this character towards its target_pos, avoiding obstacles,
///										so long as it's not controlled by the player. If no path can
///										be found it is teleported to the target_pos
function chase_target() {
	var dist_move_speed_modifier = (sqr(target_pos[0] - x) + sqr(target_pos[1] - y))
									/ sqr(sprite_width / 2)
	var move_speed = clamp(WALK_SPEED + dist_move_speed_modifier, WALK_SPEED, WALK_SPEED * 2)

	mp_potential_settings(180, 30, 1, false)
	if(mp_potential_path_object(path, target_pos[0], target_pos[1], move_speed, 4, obj_brick)) {
		path_start(path, move_speed, path_action_stop, false)
		if(follower != noone) {
			follower.set_target_pos(x, y, target_pos[2])
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
function teleport_character(teleport_pos_x = target_pos[0], teleport_pos_y = target_pos[1]) {
	set_target_pos(teleport_pos_x, teleport_pos_y, target_pos[2])
	if(follower != noone) {
		follower.teleport_character(target_pos[0], target_pos[1])
	}
	sprite_index = teleport_sprite
	character_teleporting = true
}