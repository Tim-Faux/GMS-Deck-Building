draw_self()

draw_energy_cost(energy_cost, flexpanels)
draw_attacker_selection_type_text(attacker_selection_type, allowed_classes, flexpanels)
draw_card_type(card_type, flexpanels)
draw_description(card_description, flexpanels)

if(show_energy_error) {
	show_not_enough_energy_error()
}