#macro WALK_SPEED 7.8
#macro MAX_SPRITE_SCALE_FRAME_INDEX 14
#macro MIN_DIST_FOR_ALLIES_TO_MOVE 3

move_north_west_sprite =	noone
move_north_sprite =			noone
move_north_east_sprite =	noone
move_east_sprite =			noone
move_south_east_sprite =	noone
move_south_sprite =			noone
move_south_west_sprite =	noone
move_west_sprite =			noone

stand_still_sprite =		noone
teleport_sprite =			spr_player_teleport_effect

arena = false
collidable_items = find_room_collision_items(room)
if(player_current_health == -1)
	player_current_health = player_max_health

target_pos = new character_position_target(x, y, 0, sprite_width, sprite_height)
path = path_add()
character_teleporting = false
set_follow_target()
teleport_effect_subimage = 0
character_teleported = true
character_moving = false

dir_player_enters_room = dir_to_place_player.Top
dist_to_move_chara = 0
on_walk_animation_end = undefined
chara_leaving_room = undefined

/// @desc								Sets the controlled character's initial position so they are
///											next to the obj_map_swap_trigger with pos_num equal to
///											pos_num_to_swap_to and in the direction of place_player_dir
function set_initial_pos() {
	if(is_controlled_chara) {
		for(var map_swap_index = 0; map_swap_index < instance_number(obj_map_swap_trigger); map_swap_index++) {
			var swap_trigger = instance_find(obj_map_swap_trigger, map_swap_index)
			if(variable_global_exists("pos_num_to_swap_to") && global.pos_num_to_swap_to == swap_trigger.pos_num) {
				var dist_to_walk = 0
				var normalized_sprite_width = sprite_width - sprite_xoffset
				var normalized_sprite_height = sprite_height - sprite_yoffset
				switch(swap_trigger.place_player_dir) {
					case dir_to_place_player.Top :
						x = swap_trigger.x
						y = swap_trigger.bbox_bottom + normalized_sprite_height
						dist_to_walk = swap_trigger.sprite_height + (2 * normalized_sprite_height) +
											(sprite_height / 2)
						break
					case dir_to_place_player.Left :
						x = swap_trigger.bbox_right + normalized_sprite_width
						y = swap_trigger.y
						dist_to_walk = swap_trigger.sprite_width + (2 * normalized_sprite_width) + 
											(sprite_width / 2)
						break
					case dir_to_place_player.Bottom :
						x = swap_trigger.x
						y = swap_trigger.bbox_top - normalized_sprite_height
						dist_to_walk = swap_trigger.sprite_height + (2 * normalized_sprite_height) + 
											(sprite_height / 2)
						break
					case dir_to_place_player.Right :
						x = swap_trigger.bbox_left - normalized_sprite_width
						y = swap_trigger.y
						dist_to_walk = swap_trigger.sprite_width + (2 * normalized_sprite_width) + 
											(sprite_width / 2)
						break
				}
				walk_to_next_room(swap_trigger.place_player_dir, dist_to_walk, undefined, false)
				break
			}
		}
	}
}

/// @desc									Sets up the character automatically walking in the given
///												direction for the given distance
/// @param {Real} dir_player_is_placed		The opposite of the direction the character will move in
/// @param {Real} dist_to_walk				How far the character will walk, this is used to determine
///												how long the animation will take
/// @param {Function} on_walk_finished		The callback function for when the walk animation is finished
/// @param {Bool} leaving_room				Flag to determine the direction the character is moving
function walk_to_next_room(dir_player_is_placed, dist_to_walk, on_walk_finished, leaving_room) {
	dir_player_enters_room = dir_player_is_placed
	dist_to_move_chara = dist_to_walk / WALK_SPEED
	on_walk_animation_end = on_walk_finished
	chara_leaving_room = leaving_room
	set_room_switch_trigger_sprite(dir_player_is_placed, leaving_room)
	animate_player_leaving_room()
}

/// @desc								Uses the variables set up in walk_to_next_room to have the
///											character leave the room. NOTE: This should be called
///											every frame in the step function to animate properly
function animate_player_leaving_room() {
	var walk_direction = 1
	if(chara_leaving_room) {
		walk_direction = -1	
	}
	switch (dir_player_enters_room) {
		case dir_to_place_player.Top:
			move_vertically(-WALK_SPEED * walk_direction)
			break
		case dir_to_place_player.Left:
			move_horizontally(-WALK_SPEED * walk_direction)
			break
		case dir_to_place_player.Bottom:
			move_vertically(WALK_SPEED * walk_direction)
			break
		case dir_to_place_player.Right:
			move_horizontally(WALK_SPEED * walk_direction)
			break
	}
	dist_to_move_chara--
	
	if(dist_to_move_chara <= 0)
	{
		if(!chara_leaving_room) {
			global.room_switching = false
		}
		if(on_walk_animation_end != undefined && is_method(on_walk_animation_end)) {
			method_call(on_walk_animation_end)
		}
	}	
}

/// @desc								Removes health from the player equal to damage_taken and
///											check if player is still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	player_current_health -= damage_taken
	if(instance_number(ui_health_bar) > 0) {
		for(var health_bar_index = 0; health_bar_index < instance_number(ui_health_bar); health_bar_index++) {
			var health_bar_instance = instance_find(ui_health_bar, health_bar_index)
			if(health_bar_instance.associated_chara == object_index) {
				health_bar_instance.find_chara_health_x_scale()
			}
		}
	}
	
	show_debug_message(player_current_health)
	if(player_current_health <= 0)
		show_debug_message("Player is dead")
}

/// @desc							Moves this character on the x axis and checks if moving would cause
///										the character to collide with an obj_wall. If so it moves this
///										character to the edge of that wall
/// @param {Real} x_movement		This characters rightward velocity (Negative for leftward movement)
function move_horizontally(x_movement) {
	for(var x_step = abs(x_movement); x_step > 0; x_step--) {
		var signed_x_step = x_movement < 0 ? -x_step : x_step
		if (!place_meeting(x + signed_x_step, y, collidable_items)) {
			x += signed_x_step * image_xscale
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
		if (!place_meeting(x, y + signed_y_step, collidable_items)) {
			y += signed_y_step * image_yscale
			break
		}
	}
}

/// @desc							Updates the character's sprite based on their movement direction
/// @param {Real} movement_angle	The angle this character is moving towards
function set_movement_sprite(movement_angle) {
	var y_sprite_index = 1
	var x_sprite_index = 1
	if(character_moving) {
		y_sprite_index = round(-dsin(movement_angle)) + 1
		x_sprite_index = round(dcos(movement_angle)) + 1
	}
	var movement_sprites = get_movement_sprites_array()
	sprite_index = movement_sprites[y_sprite_index][x_sprite_index]
}

/// @desc										Updates the character's sprite based on the given direction
/// @param {Real} direction_player_enters_room	The direction the player character enters the room from.
///													NOTE: This is always the place_player_dir of the
///													trigger, which is the opposite of the direction they move
/// @param {Bool} leaving_room					Flag to determine if the player is entering or leaving
///													the room
function set_room_switch_trigger_sprite(direction_player_enters_room, leaving_room) {
	var movement_sprites = get_movement_sprites_array()

	switch (direction_player_enters_room) {
		case dir_to_place_player.Bottom:
			sprite_index = movement_sprites[!leaving_room * 2][1]
			break
		case dir_to_place_player.Right:
			sprite_index = movement_sprites[1][!leaving_room * 2]
			break
		case dir_to_place_player.Top:
			sprite_index = movement_sprites[leaving_room * 2][1]
			break
		case dir_to_place_player.Left:
			sprite_index = movement_sprites[1][leaving_room * 2]
			break
	}
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

/// @desc							Struct to handle finding where the AI characters should path to
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
		x = x_intent - ((_sprite_width + SPACE_BETWEEN_FOLLOWERS) * dcos(_angle))
		y = y_intent + ((_sprite_height + SPACE_BETWEEN_FOLLOWERS) * dsin(_angle))
	}
	
	/// @desc										Attempts to find a space this character fits by shifting
	///													them horizontally and vertically outside of the
	///													collision box
	/// @param {Id.Instance, Id.TileMapElement} collision		The object this character collided
	///																with when attempting to place
	///																their target position
	/// @param {struct} bbox_to_origin_dist			The struct containing the distance from the origin
	///													to the bbox left, top, right, and bottom edge
	static find_open_space = function(collision, bbox_to_origin_dist) {
		var collision_bounds = get_collision_bounds(collision, bbox_to_origin_dist)
		if(abs(dcos(angle)) >= abs(dsin(angle))) {
			shift_on_x(collision_bounds, bbox_to_origin_dist)
		}
		else {
			shift_on_y(collision_bounds, bbox_to_origin_dist)
		}	
	}
	
	/// @desc											Finds each edge of the given collision hitbox
	/// @param {Id.Instance, Id.TileMapElement} collision	The item that the character has collided with
	/// @param {struct} bbox_to_origin_dist				The struct containing the distance from the origin
	///														to the bbox left, top, right, and bottom edge
	/// @returns {struct}								A struct containing the "left", "top", "right",
	///														and "bottom" edges of the given collision
	static get_collision_bounds = function (collision, bbox_to_origin_dist) {
		var tilemap_collision = layer_tilemap_get_colmask(collision)
		if(tilemap_collision != -1) {
			var collision_pos = find_tile_collision(x + bbox_to_origin_dist.left,
													y + bbox_to_origin_dist.top, 
													x + bbox_to_origin_dist.right, 
													y + bbox_to_origin_dist.bottom,
													collision)
			if(collision_pos != -1) {
				var tile_width = tilemap_get_tile_width(collision)
				var tile_height = tilemap_get_tile_height(collision)
				return { left	:	collision_pos[0],
						 top	:	collision_pos[1],
						 right	:	collision_pos[0] + tile_width,
						 bottom	:	collision_pos[1] + tile_height }
			}
		}
		else {
			return { left	:	collision.bbox_left,
					 top	:	collision.bbox_top,
					 right	:	collision.bbox_right,
					 bottom	:	collision.bbox_bottom }
		}
	}
	
	/// @desc										Finds if there is a tile in the given tile map
	///													that is within the given area
	/// @param {Real} x1							The left side of the area to check
	/// @param {Real} y1							The top of the area to check
	/// @param {Real} x2							The right side of the area to check
	/// @param {Real} y2							The bottom of the area to check
	/// @param {Id.TileMapElement} tilemap_id		The tilemap to check tiles from
	/// @returns {Array<Real>}						An array with the first index being the x position
	///													and the second index being the y position of
	///													the first collision found, or -1 if none found
	static find_tile_collision = function(x1, y1, x2, y2, tilemap_id) {
		var tile_width = tilemap_get_tile_width(tilemap_id)
		var tile_height = tilemap_get_tile_height(tilemap_id)
		
		var max_y = y1 > y2 ? y1 + tile_height : y2 + tile_height
		var max_x = x1 > x2 ? x1 + tile_height : x2 + tile_height
		
		for(var tile_y_to_check = y1; tile_y_to_check < max_y; tile_y_to_check += tile_height) {
			for(var tile_x_to_check = x1; tile_x_to_check < max_x; tile_x_to_check += tile_width) {
				var tile_data = tilemap_get_at_pixel(tilemap_id, tile_x_to_check, tile_y_to_check)
				if(!tile_get_empty(tile_data)) {
					var tile_x = tilemap_get_cell_x_at_pixel(tilemap_id, tile_x_to_check, tile_y_to_check) 
					var tile_y = tilemap_get_cell_y_at_pixel(tilemap_id, tile_x_to_check, tile_y_to_check) 
					if(tile_x != -1) {
						return [tile_x * tile_width, tile_y * tile_height]
					}
				}
			}
		}
		return -1
	}
	
	/// @desc								Attempts to shift this character horizontally to the edge of the
	///											collision box so long as it doesnt pass the x_intent
	/// @param {struct} collision_bounds		The struct containting the edges of object collided with
	/// @param {struct} bbox_to_origin_dist		The struct containing the distance from the origin to the
	///												bbox left, top, right, and bottom edge
	/// @param {bool} shift_y_attempted			Optional flag to determine if shifting y should be attempted
	///												if shifting x fails
	static shift_on_x = function(collision_bounds, bbox_to_origin_dist, shift_y_attempted = false) {
		if(collision_bounds.right < x_intent) {
			x = collision_bounds.right - bbox_to_origin_dist.left + 1
		}
		else if(collision_bounds.left > x_intent) {
			x = collision_bounds.left - bbox_to_origin_dist.right - 1
		}
		else if(!shift_y_attempted) {
			shift_on_y(collision_bounds, bbox_to_origin_dist, true)
		}
		else {
			x = x_intent
			y = y_intent
		}
	}
	
	/// @desc									Attempts to shift this character vertically to the edge of
	///												the collision box so long as it doesnt pass the y_intent
	/// @param {struct} collision_bounds		The struct containting the edges of object collided with
	/// @param {struct} bbox_to_origin_dist		The struct containing the distance from the origin to the
	///												bbox left, top, right, and bottom edge
	/// @param {bool} shift_x_attempted			Optional flag to determine if shifting x should be attempted 
	///												if shifting y fails
	static shift_on_y = function(collision_bounds, bbox_to_origin_dist, shift_x_attempted = false) {
		if(collision_bounds.bottom < y_intent) {
			y = collision_bounds.bottom - bbox_to_origin_dist.top + 1
		}
		else if(collision_bounds.top > y_intent) {
			y = collision_bounds.top - bbox_to_origin_dist.bottom - 1
		}
		else if(!shift_x_attempted) {
			shift_on_x(collision_bounds, bbox_to_origin_dist, true)
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
	character_moving = true
	target_pos.update_target_pos(leader_x, leader_y, angle, sprite_height, sprite_width)
	var bbox_edge_to_origin_dist = { left :	bbox_left - x,
									 top :	bbox_top - y,
									 right:	bbox_right - x,
									 bottom:bbox_bottom - y}
	var num_open_space_attempts = 0
	while(true) {
		var collision = collision_rectangle(ceil(target_pos.x + bbox_edge_to_origin_dist.left) + 1,
											ceil(target_pos.y + bbox_edge_to_origin_dist.top) + 1,
											floor(target_pos.x + bbox_edge_to_origin_dist.right) - 1,
											floor(target_pos.y + bbox_edge_to_origin_dist.bottom) - 1,
											collidable_items, false, false)
		if(collision != noone && num_open_space_attempts < 10) {
			target_pos.find_open_space(collision, bbox_edge_to_origin_dist)
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
	var dist_to_target_pos_squared = sqr(target_pos.x - x) + sqr(target_pos.y - y)
	if(dist_to_target_pos_squared > sqr(MIN_DIST_FOR_ALLIES_TO_MOVE)) {
		if(variable_global_exists("pathing_grid") && global.pathing_grid != -1) {
			var dist_move_speed_modifier = dist_to_target_pos_squared / sqr(sprite_width / 2)
			var move_speed = clamp(WALK_SPEED + dist_move_speed_modifier, WALK_SPEED, WALK_SPEED * 2)
		
			var x_offset = floor((bbox_left - x) + (bbox_right - bbox_left) / 2)
			var y_offset = floor((bbox_top - y) + (bbox_bottom - bbox_top) / 2)
			if(mp_grid_path(global.pathing_grid, path, x + x_offset, y + y_offset, target_pos.x + x_offset, target_pos.y + y_offset, true)) {
				path_start(path, move_speed, path_action_stop, false)

				if(follower != noone) {
					follower.set_target_pos(x, y, target_pos.angle)
				}
			}
			else {
				path_end()
				character_moving = false
				teleport_character()
			}
		}
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
	sprite_index = stand_still_sprite
	teleport_effect_subimage = 0
	character_teleporting = true
	character_teleported = false
}

/// @desc							Scales the current sprite based on which subimage the teleport effect is at,
///										and moves this character to their target position after the teleport
///										effect finishes the first time
function scale_sprite_for_teleport() {
	if(!character_teleported){
		if(teleport_effect_subimage >= sprite_get_number(teleport_sprite)) {
			x = target_pos.x
			y = target_pos.y
			teleport_effect_subimage = 0
			character_teleported = true
		}
		else if(teleport_effect_subimage >= sprite_get_number(teleport_sprite) / 2 &&
				teleport_effect_subimage < MAX_SPRITE_SCALE_FRAME_INDEX) {
			var sprite_shrink_scale = clamp(1 - power(teleport_effect_subimage / 
														MAX_SPRITE_SCALE_FRAME_INDEX, 8), 0, 1)
			image_xscale = sprite_shrink_scale
			image_yscale = sprite_shrink_scale
		}
	}
	else {
		if(teleport_effect_subimage <= sprite_get_number(teleport_sprite) / 2) {
			var sprite_growth_scale = clamp(power((teleport_effect_subimage / 
													MAX_SPRITE_SCALE_FRAME_INDEX) + 0.5, 8), 0, 1)
			image_xscale = sprite_growth_scale
			image_yscale = sprite_growth_scale
		}
		else if(teleport_effect_subimage >= sprite_get_number(teleport_sprite)) {
			image_xscale = 1
			image_yscale = 1
			teleport_effect_subimage = 0
			character_teleporting = false
			character_teleported = false
		}
	}
}