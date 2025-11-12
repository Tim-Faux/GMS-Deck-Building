#macro NOT_ENOUGH_ENERGY_TO_PLAY_THIS_CARD "Not enough energy to play this card!"
#macro PADDING_BETWEEN_CARD_DESCRIPTION_LINES 2

flexpanels = create_card_flexpanels()

card_selected = false
card_start_x_position = x
card_start_y_position = y
show_energy_error = false

#region THIS NEED TO BE IMPLEMENTED IN EACH CARD
//Be sure to check the Variable Definitions, there are many variables to manipulate there
card_description = "This is example text of the card's description"

/// @description							The unique action of the card when it is played
card_action = function (selected_chara, enemy_instance) {
	for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
		enemy_instance.hit_by_player(selected_chara[chara_index].get_attack())
	}
}
#endregion

/// @description							Checks to see if no other cards are selected then allows this
///												card to be selected
function select_card() {
	if(!card_selected && ui_player_hand.card_can_be_selected && visible && is_top_layer(layer)) {
		card_selected = true
		ui_player_hand.card_can_be_selected = false
		card_start_x_position = x
		card_start_y_position = y
		x = mouse_x - (sprite_width / 2)
		y = mouse_y - (sprite_height / 2)
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
			defender_selection_type,
			allowed_classes,
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
/// @param {Array<Id.Instance>} selected_chara	The character(s) selected to for the card's action
/// @param {Id.Instance} enemy_instance			The enemy selected to take damage
function card_has_been_played(selected_chara, enemy_instance) {
	ui_player_energy.remove_from_player_current_energy(energy_cost)
	card_action(selected_chara, enemy_instance)
	discard_card()
}

/// @description							The callback function for obj_target_selection_handler,
///												reseting the card position if playing it was canceled
function reset_card() {
	x = card_start_x_position
	y = card_start_y_position
}

/// @description							Creates the flexpanels for the card, with nodes for outside_border,
///												 background, image_box, energy_circle, and description_box
/// @returns								The parent node of the flex panel
function create_card_flexpanels() {
	var node = flexpanel_create_node({ 
		name : "outside_border", 
		width : sprite_width,
		height : sprite_height,
		padding : 4,
		nodes : [
		{
			name : "background",
			border : 8,
			gap : 20,
			nodes : [
			{
				name : "image_box",
				height : 113,
				flexDirection : "row",
				gap : 9,
				nodes : [
				{
					name : "card_type",
					margin : 1,
					width : 20,
					height : 20,
					top : 26
				},
				{
					name : "attacker_selection_type",
					width : "45%",
					height : 60
				},
				]
			},
			{
				name : "description_box",
				height : 97,
				padding : 2
			}]
		},
		{
			name : "energy_circle",
			width : 31,
			height : 31,
			margin : 1,
			positionType : "absolute"
		}]
	})
	
	flexpanel_calculate_layout(node, sprite_width, sprite_height, flexpanel_direction.LTR)
	return node
}

#region flexPanel debug code
//This is the flex panel translated for the debug menu flex panel, it should not be uncommented as it
//		will not work out of the box, but it is very useful for seeing what it looks like.
//	NOTE for some reason it adds a 4 pixle border around everything, so it looks like its falling off
//		the bottom when it's not actually
//
//To activate the debug menu run this code: show_debug_overlay(true)
/*
{
	"name" : "outside_border",
	"width" : 128,
	"height" : 256,
	"border" : 4,
	"nodes" : [
	{
		"name" : "background",
		"border" : 8,
		"gap" : 20,
		"nodes" : [
		{
			"name" : "image_box",
			"height" : 113,
			"flexDirection" : "row",
			"gap" : 9,
			"nodes" : [
			{
				"name" : "card_type",
				"margin" : 1,
				"width" : 20,
				"height" : 20,
				"top" : 26
			},
			{
				"name" : "attacker_selection_type",
				"width" : "45%",
				"height" : 60
			}]
		},
		{
			"name" : "description_box",
			"height" : 97,
			"padding" : 2
		}]
	},
	{
		"name" : "energy_circle",
		"width" : 31,
		"height" : 31,
		"margin" : 1,
		"positionType" : "absolute"
	}]
}
*/
#endregion

/// @description							Draws the amount of energy needed to play the card in the
///												top left hand corner. NOTE: This can only be called in
///												the draw function otherwise it will not work
function draw_energy_cost() {
	draw_set_colour(c_white)
	draw_set_alpha(1)
	draw_set_font(energy_cost_font)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	var energy_circle_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanels, "energy_circle"), false)
	var text_x_pos = x + energy_circle_panel.left + (energy_circle_panel.width / 2)
	var text_y_pos = y + energy_circle_panel.top + ceil(energy_circle_panel.height / 2)
	var text_size_scale = find_energy_cost_text_scaling(energy_circle_panel)
	
	draw_text_transformed(text_x_pos, text_y_pos, energy_cost, text_size_scale, text_size_scale, 0);
}

/// @description										Finds the scaling needed for the energy cost text
/// @param {Array<Id.Instance>} energy_circle_panel		The panel that the energy cost will be displayed in
/// @returns											The scaling factor of the text
function find_energy_cost_text_scaling(energy_circle_panel) {
	var max_string_width = energy_circle_panel.width -  energy_circle_panel.paddingLeft
													- energy_circle_panel.paddingRight
	var max_string_height = energy_circle_panel.height - energy_circle_panel.paddingTop
													- energy_circle_panel.paddingBottom

	var text_size_x_scale = max_string_width / string_width(energy_cost)
	var text_size_y_scale = max_string_height / string_height(energy_cost)
	if (text_size_x_scale > text_size_y_scale) {
	    return text_size_y_scale
	}
	else {
		return text_size_x_scale	
	}
}

/// @description							Finds which attackers are selected for the card and shows the
///												prompt for it in the top center of the card NOTE: This can
///												only be called in the draw function otherwise it will not work
function draw_attacker_selection_type_text() {
	draw_set_colour(c_white)
	draw_set_alpha(1)
	draw_set_font(attacker_selection_type_font)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	
	var attacker_selection_type_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanels, "attacker_selection_type"), false)
	var text_x_pos = x + attacker_selection_type_panel.left + (attacker_selection_type_panel.width / 2)
	var text_y_pos = y + attacker_selection_type_panel.top
	var attacker_selection_type_text = find_attacker_selection_type_string()
	var line_seperation = string_height(attacker_selection_type_text) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	var text_max_width = attacker_selection_type_panel.width - attacker_selection_type_panel.paddingLeft 
														- attacker_selection_type_panel.paddingRight
	draw_text_ext(text_x_pos, text_y_pos, attacker_selection_type_text, line_seperation, text_max_width)
}

/// @description							Checks the attacker_selection_type and allowed_classes to
///												determine what text should be displayed
/// @returns								The string of all the allowed classes for selecting which
///												characters are allowed to attack for this card
function find_attacker_selection_type_string() {
	if(attacker_selection_type == enum_card_selection_target.all_players) {
		return "All"
	}
	else if(attacker_selection_type == enum_card_selection_target.any_class || array_contains(allowed_classes, chara_class.all_chara)) {
		return "Any"
	}
	else {
		var allowed_classes_string = ""
		if(array_contains(allowed_classes, chara_class.damage)) {
			allowed_classes_string = string_concat(allowed_classes_string, ", ", "dmg")
		}
		if(array_contains(allowed_classes, chara_class.science)) {
			allowed_classes_string = string_concat(allowed_classes_string, ", ", "sci")
		}
	
		if(string_starts_with(allowed_classes_string, ", ")) {
			allowed_classes_string = string_delete(allowed_classes_string, 0, 2)
		}
		return allowed_classes_string
	}
}

/// @description							Draws the symbol indicating which type of card this is, if 
///												it's assigned NOTE: This can only be called in the draw 
///												function otherwise it will not work
function draw_card_type() {
	draw_set_colour(c_white)
	draw_set_alpha(1)
	draw_set_font(attacker_selection_type_font)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	
	var card_type_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanels, "card_type"), false)
	var text_x_pos = x + card_type_panel.left
	var text_y_pos = y + card_type_panel.top
	
	if(card_type == card_type.attack) {
		draw_sprite(spr_attack_symbol, -1, text_x_pos, text_y_pos)
	}
	else if(card_type == card_type.ability) {
		draw_sprite(spr_ability_symbol, -1, text_x_pos, text_y_pos)
	}
}

/// @description							Draws the text from card_description within the description_box 
///												flex panel NOTE: This can only be called in the draw 
///												function otherwise it will not work
function draw_description() {
	draw_set_colour(c_black)
	draw_set_alpha(1)
	draw_set_font(description_font)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanels, "description_box"), false)
	var text_x_pos = x + description_box_panel.paddingLeft + description_box_panel.left
	var text_y_pos = y + description_box_panel.paddingTop + description_box_panel.top
	var line_seperation = string_height(card_description) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	var text_max_width = description_box_panel.width - description_box_panel.paddingLeft 
														- description_box_panel.paddingRight
	var text_max_height = description_box_panel.height - description_box_panel.paddingTop
													- description_box_panel.paddingBottom

	draw_text_ext(text_x_pos, text_y_pos, card_description, line_seperation, text_max_width)
}