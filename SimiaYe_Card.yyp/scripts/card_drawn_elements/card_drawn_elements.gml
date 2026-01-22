#macro CARD_ENERGY_COST_FONT				fnt_energy_cost
#macro CARD_ATTACKER_SELECTION_TYPE_FONT	fnt_attacker_selection_type
#macro CARD_DESCRIPTION_FONT				fnt_card_description
#macro ENERGY_CIRCLE_COLOR					make_colour_rgb(0, 174, 240)

/// @description										Creates the flexpanels for the card, with nodes for
///															outside_border, background, image_box,
///															energy_circle, and description_box
/// @param {Real} spr_width								The width of the card sprite
/// @param {Real} spr_height							The height of the card sprite
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
/// @returns											The parent node of the flex panel
function create_card_flexpanels(spr_width, spr_height, spr_xscale = 1, spr_yscale = 1) {
	var node = flexpanel_create_node({ 
		name : "outside_border", 
		width : spr_width,
		height : spr_height,
		borderHorizontal : 4 * spr_xscale,
		borderVertical : 4 * spr_yscale,
		nodes : [
		{
			name : "background",
			borderHorizontal : 8 * spr_xscale,
			borderVertical : 8 * spr_yscale,
			gap : 20 * spr_yscale,
			nodes : [
			{
				name : "image_box",
				height : 113 * spr_yscale,
				flexDirection : "row",
				gap : 9 * spr_xscale,
				nodes : [
				{
					name : "card_type",
					marginHorizontal : 1 * spr_xscale,
					marginVertical : 1 * spr_yscale,
					width : 20 * spr_xscale,
					height : 20 * spr_yscale,
					top : 26 * spr_yscale
				},
				{
					name : "attacker_selection_type",
					width : "45%",
					height : 60 * spr_yscale
				},
				]
			},
			{
				name : "description_box",
				height : 97 * spr_xscale,
				paddingHorizontal : 2 * spr_xscale,
				paddingVertical : 2 * spr_yscale
			}]
		},
		{
			name : "energy_circle",
			width : 31 * spr_xscale,
			height : 31 * spr_yscale,
			marginHorizontal : 1 * spr_xscale,
			marginVertical : 1 * spr_yscale,
			positionType : "absolute"
		}]
	})
	
	flexpanel_calculate_layout(node, spr_width, spr_height, flexpanel_direction.LTR)
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

/// @description										Draws the amount of energy needed to play the card
/// 														in the top left hand corner. 
/// 														NOTE: This can only be called in the draw function
/// 														otherwise it will not work
/// @param {Real} energy_cost							The energy cost to be displayed in the top left corner
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
function draw_energy_cost(energy_cost, card_flexpanels) {
	if(energy_cost >= 0) {
		draw_energy_circle(card_flexpanels)
		
		draw_set_colour(c_white)
		draw_set_alpha(1)
		draw_set_font(CARD_ENERGY_COST_FONT)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
	
		var energy_circle_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "energy_circle"), false)
		var text_x_pos = x + energy_circle_panel.left + (energy_circle_panel.width / 2)
		var text_y_pos = y + energy_circle_panel.top + ceil(energy_circle_panel.height / 2)
		var text_size_scale = find_energy_cost_text_scaling(energy_circle_panel)
	
		draw_text_transformed(text_x_pos, text_y_pos, energy_cost, text_size_scale, text_size_scale, 0)
	}
}

/// @description										Creates a blue circle in the energy_circle panel
/// 														NOTE: This can only be called in the draw 
/// 														function otherwise it will not work
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
function draw_energy_circle(card_flexpanels) {
	draw_set_colour(ENERGY_CIRCLE_COLOR)
	draw_set_alpha(1)
	var energy_circle_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "energy_circle"), false)
	var circle_x_pos = x + energy_circle_panel.left + (energy_circle_panel.width / 2)
	var circle_y_pos = y + energy_circle_panel.top + ceil(energy_circle_panel.height / 2)
	
	draw_circle(circle_x_pos, circle_y_pos, energy_circle_panel.width / 2, false)
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

/// @description										Finds which attackers are selected for the card and shows the
///															prompt for it in the top center of the card NOTE: This can
///															only be called in the draw function otherwise it will not work
/// @param {card_selection_target} attacker_selection_type		The card_selection_target to determine how
///																	many attacker are selected
/// @param {Array<chara_class>} allowed_classes			Array of all the allowed classes to be displayed
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
function draw_attacker_selection_type_text(attacker_selection_type, allowed_classes, card_flexpanels, x_scale = 1, y_scale = 1) {
	draw_set_colour(c_white)
	draw_set_alpha(1)
	draw_set_font(CARD_ATTACKER_SELECTION_TYPE_FONT)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	
	var attacker_selection_type_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "attacker_selection_type"), false)
	var text_x_pos = x + attacker_selection_type_panel.left + (attacker_selection_type_panel.width / 2)
	var text_y_pos = y + attacker_selection_type_panel.top
	var attacker_selection_type_text = find_attacker_selection_type_string(attacker_selection_type, allowed_classes)
	var line_seperation = string_height(attacker_selection_type_text) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	var text_max_width = attacker_selection_type_panel.width - attacker_selection_type_panel.paddingLeft 
														- attacker_selection_type_panel.paddingRight
	draw_text_ext_transformed(text_x_pos, text_y_pos, attacker_selection_type_text, line_seperation, text_max_width, x_scale, y_scale, 0)
}

/// @description										Checks the attacker_selection_type and allowed_classes to
///															determine what text should be displayed
/// @param {card_selection_target} attacker_selection_type		The card_selection_target to determine
///																		how many attacker are selected
/// @param {Array<chara_class>} allowed_classes			Array of all the allowed classes to be displayed
/// @returns											The string of all the allowed classes for selecting which
///															characters are allowed to attack for this card
function find_attacker_selection_type_string(attacker_selection_type, allowed_classes) {
	if(attacker_selection_type == card_selection_target.all_players) {
		return "All"
	}
	else if(attacker_selection_type == card_selection_target.any_class || array_contains(allowed_classes, chara_class.all_chara)) {
		return "Any"
	}
	else if (attacker_selection_type == card_selection_target.random_chara) {
		return "Random"	
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

/// @description										Draws the symbol indicating which type of card this is, if 
///															it's assigned NOTE: This can only be called in the draw 
///															function otherwise it will not work
/// @param {card_type} type_of_card						The type of card being played
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
function draw_card_type(type_of_card, card_flexpanels) {
	var card_type_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "card_type"), false)
	var sprite_x_pos = x + card_type_panel.left
	var sprite_y_pos = y + card_type_panel.top

	if(type_of_card == card_type.attack) {
		draw_sprite_stretched(spr_attack_symbol, -1, sprite_x_pos, sprite_y_pos, card_type_panel.width, card_type_panel.height)
	}
	else if(type_of_card == card_type.ability) {
		draw_sprite_stretched(spr_ability_symbol, -1, sprite_x_pos, sprite_y_pos, card_type_panel.width, card_type_panel.height)
	}
}

/// @description										Draws the text from card_description within the
///															description_box flex panel
///															NOTE: This can only be called in the draw
///															function otherwise it will not work
/// @param {String} card_description					The text to be displayed at the bottom of the card
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
function draw_description(card_description, card_flexpanels, x_scale = 1, y_scale = 1) {
	draw_set_colour(c_black)
	draw_set_alpha(1)
	draw_set_font(CARD_DESCRIPTION_FONT)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "description_box"), false)
	var text_x_pos = x + description_box_panel.paddingLeft + description_box_panel.left
	var text_y_pos = y + description_box_panel.paddingTop + description_box_panel.top
	var line_seperation = string_height(card_description) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	
	var text_max_width = (description_box_panel.width - description_box_panel.paddingLeft 
														- description_box_panel.paddingRight)
														/ x_scale
														
	draw_text_ext_transformed(text_x_pos, text_y_pos, card_description, line_seperation, text_max_width, x_scale, y_scale, 0)
}