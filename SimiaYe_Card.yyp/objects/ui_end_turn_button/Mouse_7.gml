/// @desc			Checks if the End Turn button can be pressed and coordinates the end of the player's turn
if(is_top_layer(layer) && button_clicked && button_can_be_pressed) {
	button_can_be_pressed = false
	image_alpha = 1
	end_player_turn()
	start_enemy_turn()
}