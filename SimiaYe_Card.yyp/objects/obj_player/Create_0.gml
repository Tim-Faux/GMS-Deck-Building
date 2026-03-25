#macro WALK_SPEED 6
#macro MAX_SPRITE_SCALE_FRAME_INDEX 14
#macro MIN_DIST_FOR_ALLIES_TO_MOVE 3
#macro TIME_BETWEEN_EFFECT_TEXT 12
#macro MAX_CHARA_SHIELD 5

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
target_pos = new character_position_target(x, y, 0, sprite_width, sprite_height)
path = path_add()
character_teleporting = false
set_follow_target()
teleport_effect_subimage = 0
character_teleported = true
character_moving = false

class = chara_class.damage
active_buffs = {}
display_next_effect_text = true
effect_to_display = []
chara_shield = 0
player_current_health = player_max_health
turns_since_gain_strength_on_attack = 1

/// @desc								Handles the character being hit and check if player is
///											still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	damage_taken = clamp(damage_taken - chara_shield, 0, damage_taken)
	player_current_health = clamp(player_current_health - damage_taken, 0, player_max_health)
	show_debug_message(player_current_health)
	if(player_current_health <= 0)
		show_debug_message("Player is dead")
}

/// @desc								Displays the damage, buffs, and debuffs applied to the chara, 
///											allowing for different quantity and color to differentiate
///											the source of the text
function display_effect_text() {
	if(display_next_effect_text) {
		if(array_length(effect_to_display) > 0) {
			var damage_data = array_shift(effect_to_display)
			var amount_of_damage = format_display_number(damage_data[0])
			var damage_text_color = damage_data[1]
			instance_create_layer(x, y, "Instances", obj_damageText,
			{
				damage_taken : amount_of_damage,
				text_color : damage_text_color
			})
			alarm[0] = TIME_BETWEEN_EFFECT_TEXT
			display_next_effect_text = false
		}
	}
}

/// @desc							Formats a number by removing any trailing 0s or decimals
/// @param {Real} num_to_format		The number to be returned after formatting
/// @returns						A string representation of the given number with trailing 0s and if
///										if needed decimal point removed
function format_display_number(num_to_format) {
	if(num_to_format == undefined) {
		return "0"	
	}
	
	var num_string = string(num_to_format)
	var decimal_pos = string_pos(num_string, ".")
	if(decimal_pos == 0) {
		return num_string
	}
	
	for(var char_index = string_length(num_string); char_index > decimal_pos - 1; char_index--) {
		if(string_ends_with(num_string, "0")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
		}
		else if (string_ends_with(num_string, ".")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
			break;
		}
		else {
			break;	
		}
	}
	if(string_length(num_string) == 0) {
		num_string = "0"
	}
	return num_string
}

/// @desc								Finds the type and amount of damage/debuffs the character does
///											when they attack
/// @returns							The struct containing the attack data of the character
function get_attack(damage_multiplier) {
	//TODO need to make this the chara's actual attacks
	var strength = 0
	if(active_buffs[$ card_buff_effects.Strength] != undefined)
		strength = active_buffs[$ card_buff_effects.Strength]
		
	var hitstrct = {
	damage : (10 + strength) * damage_multiplier,
	debuffs : [[card_debuff_effects.Poison, 3 * damage_multiplier]]
	}
	return hitstrct
}

/// @desc								Adds the amount of shield provided to the chara's shield
/// @param {Real} shield_amount			The amount of shield being added
function add_shield(shield_amount) {
	if (shield_amount > 0)
		chara_shield = clamp(chara_shield + shield_amount, 0, MAX_CHARA_SHIELD)
}

/// @desc								Heals the chara by the given amount up, but not more than,
///											their max health
/// @param {Real} health_to_add			The maximum health to be healed
function heal_chara(health_to_add) {
	if(health_to_add > 0)
		player_current_health = clamp(player_current_health + health_to_add, 0, player_max_health)
}

/// @desc										Applies a buff to this chara and adds them to the 
///													effect_to_display queue
/// @param {card_buff_effects} buff_type		The buff being applied
/// @param {Real} buff_amount					The amount of the buff being added
function apply_buff(buff_type, buff_amount) {
	if(active_buffs[$ buff_type] == undefined)
			active_buffs[$ buff_type] = buff_amount
	else
		active_buffs[$ buff_type] += buff_amount
			
	switch (buff_type) {
		case card_buff_effects.Strength:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_maroon])
			break;
		case card_buff_effects.Gain_Strength_On_Any_Attack:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_fuchsia])
			turns_since_gain_strength_on_attack = 1
			break;
	}
}

/// @desc										Increases the amount of a given buff by multiplying it
///													by amount_multipled and adds them to the 
///													effect_to_display queue
/// @param {card_buff_effects} buff_type		The buff being modified
/// @param {Real} buff_amount					The amount of the buff being added
function multiply_buff(buff_type, amount_multiplied) {
	if(active_buffs[$ buff_type] != undefined) {
			active_buffs[$ buff_type] *= amount_multiplied
	}
			
	switch (buff_type) {
		case card_buff_effects.Strength:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_maroon])
			break;
		case card_buff_effects.Gain_Strength_On_Any_Attack:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_fuchsia])
			break;
	}
}

/// @desc										Loops through each buff for this player and handles
///													what should happen with it at the end of the
///													player's turn
function trigger_end_of_turn_buffs() {
	struct_foreach(active_buffs, function (debuff_name, debuff_amount) {
		switch (debuff_name) {
			case card_buff_effects.Gain_Strength_On_Any_Attack:
				struct_remove(active_buffs, debuff_name)
				turns_since_gain_strength_on_attack = 1
				break
		}
	})
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
	character_moving = true
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
	var dist_to_target_pos_squared = sqr(target_pos.x - x) + sqr(target_pos.y - y)
	if(dist_to_target_pos_squared > sqr(MIN_DIST_FOR_ALLIES_TO_MOVE)) {
		var dist_move_speed_modifier = dist_to_target_pos_squared / sqr(sprite_width / 2)
		var move_speed = clamp(WALK_SPEED + dist_move_speed_modifier, WALK_SPEED, WALK_SPEED * 2)

		mp_potential_settings(180, 30, 1, false)
		if(mp_potential_path_object(path, target_pos.x, target_pos.y, move_speed, 4, obj_brick)) {
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