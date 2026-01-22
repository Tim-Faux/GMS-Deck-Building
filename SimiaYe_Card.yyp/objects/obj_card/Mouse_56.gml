/// @description	Attacks enemy or resets the card so other cards can be selected
if(card_selected) {
	global.object_being_clicked	= false
	card_selected = false
	ui_player_hand.card_can_be_selected = true
	if(y < card_start_y_position - (sprite_height * 1.5)) {
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