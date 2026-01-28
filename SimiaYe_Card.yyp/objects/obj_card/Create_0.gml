#macro NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD		"Not enough energy to play this card!"
#macro THIS_CARD_CAN_NOT_BE_PLAYED				"This card can not be played!"
#macro NOT_ENOUGH_CARDS_IN_DISCARD_DECK_TO_PLAY	"Not enough cards in your discard deck to play this card"
#macro NOT_ENOUGH_CARDS_IN_HAND_TO_PLAY			"Not enough cards in your hand to play this card"
#macro NOT_ENOUGH_CARDS_IN_DECK_TO_PLAY			"Not enough cards in your deck to play this card"
#macro PADDING_BETWEEN_CARD_DESCRIPTION_LINES	2
#macro CARD_SELECTION_CONFIRMATION_MOVEMENT		30

flexpanels = create_card_flexpanels(sprite_width, sprite_height)

card_selected = false
card_start_x_position = x
card_start_y_position = y
error_text = ""
is_selected = false
card_played = false
card_description_scaling = -1
card_can_be_moved = array_all(interaction_type,
						function(_val, _ind) { 
							return _val != card_interaction_type.display_card &&
									_val != card_interaction_type.selectable_card 
						})

#region THIS NEED TO BE LOOKED AT FOR EACH CARD

//Be sure to check the Variable Definitions, there are many variables to manipulate there
card_description = "This is example text of the card's description"
target_selection_order = [selection_target.character, selection_target.card, selection_target.enemy]

/// @description									The action of the card when it's drawn into the hand
card_drawn_action = function () {
	// Only implement this function if a card has an on draw effect
}

/// @description									The function run when this card is selected
///														to be played.
card_selected_action = function (remove_card_energy) {
	// Only implement this function if a card has an on selection effect
	// NOTE: If this function has a custom implementation it is likely that
	//		cancel_button_allowed will need to be false
	// NOTE: The following line must be implemented to allow the card to be played
	create_target_selection_handler(remove_card_energy)
}

/// @description									The action of the card when a character is selected
/// @param {Id.Instance} selected_chara				The character selected
chara_selected_action = function (selected_chara) {
// Only implement this function if a card has an on chara select effect
}

/// @description									The unique action of the card when it is played
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	// NOTE: The following line must be implemented to allow the card to complete
	card_action_struct.end_card_action()
}

/// @description									The unique action of the card when it is discarded
/// @param {Function} on_card_discard				The call back function for after the card is discarded
/// @param {Array} on_card_discard_args				The argurments for the on_card_discard function
card_discard_action = function (on_card_discard, on_card_discard_args) {
	// Only implement this function if a card has an on discard effect
	// NOTE: The following lines must be implemented to allow the card to be properly discarded
	if(on_card_discard != undefined && is_method(on_card_discard))
		method_call(on_card_discard, on_card_discard_args)
	ui_player_hand.remove_card(id)	
}

/// @description									The unique action of the card when it is exhausted
/// @param {Function} on_card_exhaust				The call back function for after the card is exhausted
/// @param {Array} on_card_exhaust_args				The argurments for the on_card_exhaust function
card_exhaust_action = function (on_card_exhaust, on_card_exhaust_args) {
	// Only implement this function if a card has an on exhaust effect
	// NOTE: The following lines must be implemented to allow the card to be properly exhausted
	if(on_card_exhaust != undefined && is_method(on_card_exhaust))
		method_call(on_card_exhaust, on_card_exhaust_args)
	ui_player_hand.remove_card(id)	
}

/// @description									The action of the card when the player ends their turn
/// @param {Function} on_end_turn_action			The call back function for after the end turn 
///														action completes
/// @param {Array} on_end_turn_action_args			The argurments for the on_end_turn_action function
player_turn_end_action = function (on_end_turn_action, on_end_turn_action_args) {
	// Only implement this function if a card has an on end turn effect
	// NOTE: The following lines must be implemented to allow the player's turn to end
	if(on_end_turn_action != undefined && is_method(on_end_turn_action))
		method_call(on_end_turn_action, on_end_turn_action_args)
}

#endregion

/// @description							Checks to see if no other cards are selected then allows this
///												card to be selected
function select_card() {
	if(!card_selected && !global.object_being_clicked && visible && is_top_layer(layer, mouse_x, mouse_y)) {
		global.object_being_clicked	= true
		card_selected = true
		if(card_can_be_moved) {
			card_start_x_position = x
			card_start_y_position = y
			x = mouse_x - (sprite_width / 2)
			y = mouse_y - (sprite_height / 2)
		}
	}
}

function card_released() {
	global.object_being_clicked	= false
	card_selected = false
	if(array_contains(interaction_type, card_interaction_type.default_card)) {
		ui_player_hand.card_can_be_selected = true
		if(y < card_start_y_position - (sprite_height * 0.5)) {
			if(energy_cost < 0) {
				queue_error_message(THIS_CARD_CAN_NOT_BE_PLAYED)
			}
			else {
				play_card()
			}
		}
		else {
			reset_card()
		}	
	}
}

/// @description							Handles the card being played. Allowing the player to
///												select the attacker and defender of the card
function play_card(remove_card_energy = true) {
	if (remove_card_energy && energy_cost >= 0 && ui_player_energy.get_player_current_energy() < energy_cost) {
		queue_error_message(NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD)
	}
	else if(card_selection_type == card_select_target_card.discard_deck &&
			array_length(get_player_discard_deck()) < num_cards_to_select) {
		queue_error_message(NOT_ENOUGH_CARDS_IN_DISCARD_DECK_TO_PLAY)
	}
	else {
		card_selected_action(remove_card_energy)
	}
}

/// @description							Clears error text and shows the given error message
/// @param {string} error_message			The error message to be shown to the player
function queue_error_message(error_message) {
	obj_card.error_text = ""
	error_text = error_message
	alarm_set(0, 4 * 60)
	reset_card()
}

/// @description							The callback function for obj_target_selection_handler,
///												reseting the card position if playing it was canceled
function reset_card() {
	x = card_start_x_position
	y = card_start_y_position
}

/// @description							Creates the target selection handler on a new layer above
///												the current highest layer
function create_target_selection_handler(remove_card_energy) {
	var top_layer_depth = layer_get_depth(find_top_layer())
	var target_selection_layer = layer_create(top_layer_depth - 100)
	instance_create_layer(x, y, target_selection_layer, obj_target_selection_handler, 
	{
		num_chara_to_select,
		attacker_selection_type,
		card_selection_type,
		defender_selection_type,
		allowed_classes,
		num_cards_to_select,
		card_played : id,
		target_selection_order,
		allowed_back_button_stages,
		cancel_button_allowed,
		remove_card_energy
	})
}

/// @description								The callback function for obj_target_selection_handler,
///													giving an opportunity for the card to discard the card
/// @param {Array<Id.Instance>} selected_chara	The character(s) selected for the card's action
/// @param {Array<Id.Instance>} selected_cards	The card(s) selected for the card's action
/// @param {Id.Instance} enemy_instance			The enemy selected to take damage
function card_has_been_played(selected_chara, selected_cards, enemy_instance, remove_card_energy = true) {
	if(remove_card_energy) {
		ui_player_energy.remove_from_player_current_energy(energy_cost)
	}
	
	var on_card_action_complete = undefined
	if(card_is_discarded_when_played) {
		on_card_action_complete = method(self, discard_card)
	}
	else if(card_is_exhausted_when_played) {
		on_card_action_complete = method(self, exhaust_card)
	}
	else {
		on_card_action_complete = method(self, reset_card)	
	}
	var card_action_struct = new struct_card_action(selected_chara, selected_cards, enemy_instance, on_card_action_complete)
	card_action(card_action_struct)
}

/// @description							Removes this card from the player's hand and destroy it
/// @param {Function} on_card_discard		The optional call back function for after the card
///												is discarded
/// @param {Array} on_card_discard_args		The optional argurments for the on_card_discard function
function discard_card(on_card_discard = undefined, on_card_discard_args = []) {
	if(!card_played)
		add_card_to_discard_deck(object_index)	
	card_discard_action(on_card_discard, on_card_discard_args)
}

/// @description							Removes this card from the player's hand and exhausts it
/// @param {Function} on_card_exhaust		The optional call back function for after the card
///												is exhausted
/// @param {Array} on_card_exhaust_args		The optional argurments for the on_card_exhaust function
function exhaust_card(on_card_exhaust = undefined, on_card_exhaust_args = []) {
	add_card_to_exhaust_deck(object_index)
	card_exhaust_action(on_card_exhaust, on_card_exhaust_args)
}

/// @desc												Calculates the scaling needed for the card's
///															description to remain in the description box
/// @param {String} card_description					The text to be scaled
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
/// @returns {Real}										The scaling needed to fit the text. A max of 1 and
///															minimum of 0.1. NOTE: This should be used for
///															X and Y scaling
function find_card_description_scaling(card_description, card_flexpanels) {
	draw_set_font(CARD_DESCRIPTION_FONT)
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "description_box"), false)
	var line_seperation = string_height(card_description) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	var text_max_width = (description_box_panel.width - description_box_panel.paddingLeft 
														- description_box_panel.paddingRight)
	
	var text_scale = 1
	var text_height = string_height_ext(card_description, line_seperation, text_max_width / text_scale)
	if(text_height > description_box_panel.height) {
		while(text_scale > 0.1 && text_height > description_box_panel.height / text_scale) {
			text_scale -= 0.1
			text_height = string_height_ext(card_description, line_seperation, text_max_width / text_scale)
		}
	}
	return text_scale
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
		energy_cost,
		attacker_selection_type,
		allowed_classes,
		card_description,
		card_type
	})
}