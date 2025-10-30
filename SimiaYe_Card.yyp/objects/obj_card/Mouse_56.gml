/// @description	Attacks enemy or resets the card so other cards can be selected
if(card_selected) {
	card_selected = false
	ui_player_hand.card_can_be_selected = true
	if(y < card_start_y_position - (sprite_height * 1.5)) {
		play_card()
	}
	else {
		x = card_start_x_position
		y = card_start_y_position
	}
}