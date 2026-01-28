// Inherit the parent event
event_inherited();

button_can_be_pressed = true

/// @desc			Controls the end of a players turn, filling the player's hand with cards
function end_player_turn() {
	if(instance_exists(ui_player_hand) && ui_player_hand.is_hand_visible) {
		ui_player_hand.empty_player_hand()
	}
}

/// @desc			Finds all the enemies that currently exist and allows them to take their turn
function start_enemy_turn() {
	var num_enemies = instance_number(obj_enemy)
	var enemies = array_create(num_enemies)
	for(var enemy_index = 0; enemy_index < num_enemies; enemy_index++) {
		enemies[enemy_index] = instance_find(obj_enemy, enemy_index)
	}
	
	array_sort(enemies, sort_enemies)
	
	for(var enemy_index = 0; enemy_index < num_enemies; enemy_index++) {
		enemies[enemy_index].attack_player()
	}
	//This is a temporary solution to stop the player pressing the button multiple times.
	//Eventually this should be replaced with waiting for the enemy to finish their animation
	alarm[0] = 60
}

/// @desc			Finds all the enemies that currently exist and triggers end of turn actions
function end_enemy_turn() {
	var num_enemies = instance_number(obj_enemy)
	var enemies = array_create(num_enemies)
	for(var enemy_index = 0; enemy_index < num_enemies; enemy_index++) {
		enemies[enemy_index] = instance_find(obj_enemy, enemy_index)
	}
	
	array_sort(enemies, sort_enemies)
	
	for(var enemy_index = 0; enemy_index < num_enemies; enemy_index++) {
		enemies[enemy_index].trigger_end_of_turn_debuffs()
	}
	
	button_can_be_pressed = true
	ui_player_hand.fill_player_hand()
	if(position_meeting(mouse_x, mouse_y, ui_end_turn_button)) {
		handle_mouse_enter()
	}
}

/// @desc			Basic enemy sorting algorithm to determine the farthest left enemy
function sort_enemies(enemy1, enemy2) {
	return enemy1.x - enemy2.x
}