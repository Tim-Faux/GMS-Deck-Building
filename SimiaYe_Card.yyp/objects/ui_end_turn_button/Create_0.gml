// Inherit the parent event
event_inherited();

button_can_be_pressed = true

/// @desc			Controls the end of a players turn, filling the player's hand with cards
function end_player_turn() {
	if(instance_exists(ui_player_hand) && ui_player_hand.is_hand_visible) {
		ui_player_hand.empty_player_hand(trigger_player_end_of_turn_effects)
	}
}

/// @desc			Triggers the end of turn effects and end of turn buffs on each player character
function trigger_player_end_of_turn_effects() {
	if(variable_global_exists("add_energy_on_card_draw") ) {
		global.add_energy_on_card_draw = 0
	}
	
	var num_player_charas = instance_number(obj_player)
	var player_charas = array_create(num_player_charas)
	for(var chara_index = 0; chara_index < num_player_charas; chara_index++) {
		player_charas[chara_index] = instance_find(obj_player, chara_index)
	}
	
	array_sort(player_charas, sort_players)
	
	for(var chara_index = 0; chara_index < num_player_charas; chara_index++) {
		player_charas[chara_index].trigger_end_of_turn_buffs()
	}
	
	start_enemy_turn()
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
	
	if(skip_players_next_turn) {
		skip_players_next_turn = false
		end_player_turn()
	}
	else {
		button_can_be_pressed = true
		ui_player_hand.fill_player_hand()
		ui_player_energy.reset_player_current_energy()
		if(position_meeting(mouse_x, mouse_y, ui_end_turn_button)) {
			handle_mouse_enter()
		}
	}
}

/// @desc			Basic player sorting algorithm to determine the farthest left player chara
function sort_players(chara1, chara2) {
	return chara1.x - chara2.x
}

/// @desc			Basic enemy sorting algorithm to determine the farthest left enemy
function sort_enemies(enemy1, enemy2) {
	return enemy1.x - enemy2.x
}