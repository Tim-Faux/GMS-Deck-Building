#macro NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD "Not enough energy to play this card!"
#macro PADDING_BETWEEN_CARD_DESCRIPTION_LINES 2
#macro CARD_SELECTION_CONFIRMATION_MOVEMENT 30

flexpanels = create_card_flexpanels(sprite_width, sprite_height)

card_selected = false
draw_card = true
card_start_x_position = x
card_start_y_position = y
show_energy_error = false
is_selected = false

#region THIS NEED TO BE IMPLEMENTED IN EACH CARD
//Be sure to check the Variable Definitions, there are many variables to manipulate there
card_description = "This is example text of the card's description"

/// @description									The unique action of the card when it is played
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(1)
}
#endregion

/// @description							Checks to see if no other cards are selected then allows this
///												card to be selected
function select_card() {
	if(!card_selected && !global.object_being_clicked && visible && is_top_layer(layer)) {
		global.object_being_clicked	= true
		card_selected = true
		if(!is_display_card && !is_selectable_card) {
			card_start_x_position = x
			card_start_y_position = y
			x = mouse_x - (sprite_width / 2)
			y = mouse_y - (sprite_height / 2)
		}
	}
}

/// @description							Removes this card from the player's hand and destroy it
function discard_card() {
	add_card_to_discard_deck(object_index)
	ui_player_hand.remove_card(id)
	instance_destroy()
}

/// @description							Handles the card being played. Allowing the player to
///												select the attacker and defender of the card
function play_card() {
	if (ui_player_energy.get_player_current_energy() < energy_cost) {
		show_energy_error = true
		alarm_set(0, 4 * 60)
		reset_card()
	}
	else {
		var target_selection_layer = layer_create(depth - 100)
		instance_create_layer(x, y, target_selection_layer, obj_target_selection_handler, 
		{
			num_chara_to_select,
			attacker_selection_type,
			card_selection_type,
			defender_selection_type,
			allowed_classes,
			num_cards_to_select,
			card_played : id
		})
	}
}

/// @description							Shows the error prompt for when a card is attempted to be
///												played, but the player does not have enough energy
///												NOTE: This can only be called in the draw function
///												otherwise it will not work
function show_not_enough_energy_error() {
	draw_set_colour(not_enough_energy_error_color)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_font(not_enough_energy_error_font)
	var text_x_pos = display_get_gui_width() / 2
	var text_y_pos = display_get_gui_height() / 3
	draw_text(text_x_pos, text_y_pos, NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD)
}

/// @description								The callback function for obj_target_selection_handler,
///													giving an opportunity for the card to discard the card
/// @param {Array<Id.Instance>} selected_chara	The character(s) selected for the card's action
/// @param {Array<Id.Instance>} selected_cards	The card(s) selected for the card's action
/// @param {Id.Instance} enemy_instance			The enemy selected to take damage
function card_has_been_played(selected_chara, selected_cards, enemy_instance) {
	ui_player_energy.remove_from_player_current_energy(energy_cost)
	var card_action_struct = new struct_card_action(selected_chara, selected_cards, enemy_instance)
	card_action(card_action_struct)
	discard_card()
}

/// @description							The callback function for obj_target_selection_handler,
///												reseting the card position if playing it was canceled
function reset_card() {
	x = card_start_x_position
	y = card_start_y_position
}

/// @desc								Creates a display card the size of the screen with this sprite
function create_expanded_card() {
	var screen_height = display_get_gui_height()
	var screen_width = display_get_gui_width()
	var sprite_size_scale = (screen_height - EXPANDED_CARD_PADDING) / sprite_height
	
	var card_x_pos = (screen_width - (sprite_width * sprite_size_scale)) / 2
	var card_y_pos = (screen_height - (sprite_height * sprite_size_scale)) / 2
	var new_flexpanels = create_card_flexpanels(sprite_width * sprite_size_scale, sprite_height * sprite_size_scale, sprite_size_scale, sprite_size_scale)
	
	var expanded_card_instance_id = layer_create(-200, "expanded_card_instance")
	instance_create_layer(card_x_pos, card_y_pos, expanded_card_instance_id, obj_display_card, {
		sprite_index : sprite_index,
		image_xscale : sprite_size_scale,
		image_yscale : sprite_size_scale,
		flexpanels : new_flexpanels,
		card_expanded : true,
		energy_cost,
		attacker_selection_type,
		allowed_classes,
		card_description,
		card_type
	})
}

/// @desc								Determines if the card is fully off screen and if so dont draw it
function check_on_screen() {
	var sprite_top = y - sprite_yoffset
	var sprite_left = x - sprite_xoffset
	draw_card = sprite_top + sprite_height >= 0 &&
				sprite_top < display_get_gui_height() &&
				sprite_left + sprite_width >= 0 &&
				sprite_left < display_get_gui_width()
}