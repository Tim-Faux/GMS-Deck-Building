draw_self()

draw_energy_cost(energy_cost, flexpanels)
draw_attacker_selection_type_text(attacker_selection_type, allowed_classes, flexpanels)
draw_card_type(card_type, flexpanels)
if(card_description_scaling == -1)
	card_description_scaling = find_card_description_scaling(card_description, flexpanels)
draw_description(card_description, flexpanels, card_description_scaling, card_description_scaling)

if(string_length(error_text) > 0) {
	show_error_message()
}