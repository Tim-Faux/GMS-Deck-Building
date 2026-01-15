#macro PLAYER_DEFAULT_ENERGY 7
#macro PLAYER_ENERGY_TEXT_PADDING 50

if(!variable_global_exists("player_total_energy")) {
	global.player_total_energy = PLAYER_DEFAULT_ENERGY
}
reset_player_current_energy()

/// @desc							Gets the player's current energy with amount of energy spent removed
/// @returns						The current energy the player has
function get_player_current_energy() {
	return player_current_energy	
}

/// @desc							Removes a given amount of energy from the player's current energy
/// @param {Real} num_energy		The amount of energy to remove from player's current energy supply
function remove_from_player_current_energy(num_energy) {
	player_current_energy -= num_energy
	if(player_current_energy < 0) {
		player_current_energy = 0
	}
}

/// @desc							Adds energy to the player's current energy supply
/// @param {Real} num_energy		The amount of energy to add to the player's current energy supply
function add_to_player_current_energy(num_energy) {
	player_current_energy += num_energy
}

/// @desc							Multiplies the player's energy by the given amount
/// @param {Real} energy_mult		The amount the player's energy is multiplied by
function multiply_player_current_energy(energy_mult) {
	player_current_energy *= energy_mult
}

/// @desc							Resets the player's current energy to their total energy
function reset_player_current_energy() {
	player_current_energy = global.player_total_energy
}

/// @desc							Draws the text to display the amount of energy the player has left
///										and what their total energy count is
function draw_energy_count_text() {
	draw_set_font(font)

	if(image_blend == c_white || image_blend == -1) {
		draw_set_colour(text_color)
	}
	else {
		var blend_adjusted_text_color = merge_colour(text_color, image_blend, 0.5)
		draw_set_colour(blend_adjusted_text_color)
	}

	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)

	var energy_text = $"{player_current_energy}/{global.player_total_energy}"
	var text_width = string_width(energy_text);
	var text_size_scale = 1;
	if ((sprite_width - PLAYER_ENERGY_TEXT_PADDING) > 0 && text_width > (sprite_width - PLAYER_ENERGY_TEXT_PADDING)) {
	    text_size_scale = (sprite_width - PLAYER_ENERGY_TEXT_PADDING) / text_width;
	}
	draw_text_transformed(x, y, energy_text, text_size_scale, text_size_scale, 0);

	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
}