#macro EXPANDED_CARD_PADDING 100

card_clicked = false
remove_expanded_card = false
flexpanels = create_card_flexpanels(sprite_width, sprite_height, image_xscale, image_yscale)

/// @desc								Draws a rectangle over the whole camera to dim the game
///											NOTE: this must be called in the Draw event or it won't
///											work correctly
function draw_deck_background() {
	draw_set_colour(c_black)
	draw_set_alpha(BACKGROUND_ALPHA)
	var screen_width = display_get_gui_width()
	var screen_height = display_get_gui_height()
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)	
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