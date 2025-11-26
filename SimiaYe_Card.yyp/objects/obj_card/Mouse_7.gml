if(is_selectable_card && card_selected && is_top_layer(layer)) {
	card_selected = false
	global.object_being_clicked = false
	is_selected = !is_selected
	if(is_selected) {
		y -= CARD_SELECTION_CONFIRMATION_MOVEMENT
		obj_target_selection_handler.target_selected(id)
	}
	else {
		y = card_start_y_position
		obj_target_selection_handler.target_deselected(id)
	}
}
else if(is_display_card && card_selected && is_top_layer(layer)) {
	create_expanded_card()
}