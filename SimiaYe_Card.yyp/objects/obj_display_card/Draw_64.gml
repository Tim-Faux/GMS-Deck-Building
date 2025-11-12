if(card_expanded) {
	draw_deck_background()
}

if(draw_card) {
	draw_self()

	draw_energy_cost(energy_cost, flexpanels)
	draw_attacker_selection_type_text(attacker_selection_type, allowed_classes, flexpanels, image_xscale, image_yscale)
	draw_card_type(card_type, flexpanels)
	draw_description(card_description, flexpanels, image_xscale, image_yscale)
}