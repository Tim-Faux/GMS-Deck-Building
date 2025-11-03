#macro SELECTABLE_CHARA_BACK_BUTTON_PADDING 10
#macro SELECTABLE_CHARA_CANCEL_BUTTON_PADDING 10

highlighed_chara_layer = layer_create(depth - 1, "highlighed_chara_layer")
highlighed_enemies_layer = layer_create(depth - 1, "highlighed_enemies_layer")
selected_chara = []
num_chara_selected = 0
selecting_character = true

select_target_attacker()

/// @desc						Reads the attacker_selection_type and decides whether a character
///									selection is needed
function select_target_attacker() {
	selecting_character = true
	selected_chara = []
	num_chara_selected = 0
	if(attacker_selection_type == enum_card_selection_target.all_players) {
		selected_chara = find_allowed_attackers()
		num_chara_selected = array_length(selected_chara)
		select_target_enemy()
	}
	else if(attacker_selection_type == enum_card_selection_target.any_class) {
		create_attacker_selection()
	}
	else if(attacker_selection_type == enum_card_selection_target.selected_class) {
		create_attacker_selection(allowed_classes)
	}
}

/// @desc											Finds all of the characters of the given classes
///														and creates obj_selectable_chara of them
/// @param {Array<Real>} allowed_chara_classes		The classes allowed to attack, defaulting to all_chara
function create_attacker_selection(allowed_chara_classes = [chara_class.all_chara]) {
	var all_allowed_attackers = find_allowed_attackers(allowed_chara_classes)

	for(var chara_index = 0; chara_index < array_length(all_allowed_attackers); chara_index++) {
		var sprite = all_allowed_attackers[chara_index].sprite_index
		instance_create_layer(all_allowed_attackers[chara_index].x, all_allowed_attackers[chara_index].y, highlighed_chara_layer, obj_selectable_chara, {
			sprite_index : sprite,
			chara_instance : all_allowed_attackers[chara_index]
		})
		all_allowed_attackers[chara_index].visible = false
	}
	create_back_and_cancel_buttons(true)
}

/// @desc										Searches for all characers in the room and determines if
///													their class is one of the allowed options to attack
/// @param {Array<Real>} allowed_class			The classes allowed to attack, defaulting to all_chara
function find_allowed_attackers(allowed_class = [chara_class.all_chara]) {
	var num_avaliable_charas = instance_number(obj_player)
	var allowed_attackers = array_create(0)
	for(var chara_index = 0; chara_index < num_avaliable_charas; chara_index++) {
		var chara_instance = instance_find(obj_player, chara_index)
		if (array_contains(allowed_class, chara_class.all_chara)) {
			array_push(allowed_attackers, chara_instance)
		}
		else if (array_contains(allowed_class, chara_instance.class)) {
			array_push(allowed_attackers, chara_instance)
		}
	}
	if(array_length(allowed_attackers) < num_chara_to_select) {
		num_chara_to_select = array_length(allowed_attackers)
	}
	return allowed_attackers
}

/// @desc									Creates the back and cancel buttons for the target selection
/// @param {boolean} is_attacker_select		Determines which layer the buttons will be placed on and
///												whether the back button is greyed out or not
function create_back_and_cancel_buttons(is_attacker_select) {
	var back_button_x = SELECTABLE_CHARA_BACK_BUTTON_PADDING + (sprite_get_width(object_get_sprite(ui_selectable_chara_back_button)) / 2)
	var back_button_y = display_get_gui_height() / 2 - SELECTABLE_CHARA_BACK_BUTTON_PADDING -
							(sprite_get_height(object_get_sprite(ui_selectable_chara_back_button)) / 2)
	var cancel_button_x = SELECTABLE_CHARA_CANCEL_BUTTON_PADDING + (sprite_get_width(object_get_sprite(ui_selectable_chara_back_button)) / 2)
	var cancel_button_y = display_get_gui_height() / 2 + SELECTABLE_CHARA_CANCEL_BUTTON_PADDING +
							(sprite_get_height(object_get_sprite(ui_selectable_chara_back_button)) / 2)
	
	var layer_id = highlighed_enemies_layer
	if(is_attacker_select) {
		layer_id = highlighed_chara_layer
	}
	
	instance_create_layer(back_button_x, back_button_y, layer_id, ui_selectable_chara_back_button, {
		is_back_enabled : !is_attacker_select
	})
	instance_create_layer(cancel_button_x, cancel_button_y, layer_id, ui_selectable_chara_cancel_button)
}

/// @desc									Resets the target selection to selecting an attacker and
///												hiding the target selection for the defenders
function cancel_target_selection() {
	show_chara_sprites()
	show_enemy_sprites()
	if(card_played != noone) {
		card_played.reset_card()
	}
		
	find_and_delete_related_layers(layer)
}

/// @desc						The call back function for the obj_selectable_chara, then determines if
///									a character or an enemy was being selected and forwards the action
function target_selected(selected_target) {
	if (selecting_character) {
		chara_selected(selected_target)
	}
	else {
		enemy_selected(selected_target)
	}
}

/// @desc						The call back function for the obj_selectable_chara. Handles deselecting
///									the character, cleaning up any references to their selection
function target_deselected(selected_target) {
	if (selecting_character) {
		chara_deselected(selected_target)
	}
}

/// @desc									Checks if the number of selected characters is equal to the 
///												allowed amount of characters before allowing an enemy
///												to be targeted
/// @param {Id.Instance} chara_instance		The character selected to attack an enemy
function chara_selected(chara_instance) {
	if(chara_instance == noone) {
		show_chara_sprites()
		layer_destroy_instances(highlighed_chara_layer)
	}
	else if (!array_contains(selected_chara, chara_instance)) {
		num_chara_selected++
		array_push(selected_chara, chara_instance)
	}
	
	if(num_chara_selected >= num_chara_to_select || num_chara_to_select == 0) {
		layer_destroy_instances(highlighed_chara_layer)
		show_chara_sprites()
		select_target_enemy()
	}
}

/// @desc									Removes the given character from the selected character array
///												and decrements num_chara_selected
/// @param {Id.Instance} chara_instance		The character being deselected
function chara_deselected(chara_instance) {
	var chara_index = array_get_index(selected_chara, chara_instance)
	if (chara_index > -1) {
		num_chara_selected--
		array_delete(selected_chara, chara_index, 1)
	}
}

/// @desc											Hides the given or all of the character sprites
/// @param {Array<Id.Instance>} sprites_to_hide		All of the instances desired to be no longer visible
function hide_chara_sprites(sprites_to_hide = []) {
	if(array_length(sprites_to_hide) <= 0) {
		sprites_to_hide = find_allowed_attackers()
	}
	
	for (var chara_index = 0; chara_index < array_length(sprites_to_hide); chara_index++) {
		sprites_to_hide[chara_index].visible = false
	}
}

/// @desc											Shows the given or all of the character sprites
/// @param {Array<Id.Instance>} sprites_to_show		All of the instances desired to be no longer visible
function show_chara_sprites(sprites_to_show = []) {
	if(array_length(sprites_to_show) <= 0) {
		sprites_to_show = find_allowed_attackers()
	}
	
	for (var chara_index = 0; chara_index < array_length(sprites_to_show); chara_index++) {
		sprites_to_show[chara_index].visible = true
	}
}

/// @desc									Decides whether an enemy selection is needed based on the
///												given card target
function select_target_enemy() {
	selecting_character = false
	if(defender_selection_type == enum_card_attack_target.all_enemies) {
		all_enemies_selected()
	}
	else if(defender_selection_type == enum_card_attack_target.single_enemy) {
		create_defender_selection()
	}
}

/// @desc									Applies damage from each selected character to each enemy
///												and deletes the layers used for target selection
function all_enemies_selected() {
	var enemy_instances = find_allowed_enemies()
	for(var enemy_index = 0; enemy_index < array_length(enemy_instances); enemy_index++) {
		if(enemy_instances[enemy_index] != noone) {
			for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
				enemy_instances[enemy_index].hit_by_player(selected_chara[chara_index].get_attack())
			}
		}
	}
	if(card_played != noone) {
		card_played.card_has_been_played()
	}
	find_and_delete_related_layers(layer)
}

/// @desc									Applies damage from each selected character to a single enemy
///												and deletes the layers used for target selection
/// @param {Id.Instance} enemy_instance		The enemy selected to take damage
function enemy_selected(enemy_instance) {
	if(enemy_instance != noone) {
		for (var chara_index = 0; chara_index < array_length(selected_chara); chara_index++) {
			enemy_instance.hit_by_player(selected_chara[chara_index].get_attack())
		}
		show_enemy_sprites()
		if(card_played != noone) {
			card_played.card_has_been_played()
		}
		
		find_and_delete_related_layers(layer)
	}
}

#region Get rid of these later
//TODO there is a pull request that moves this into a seperate script but right now it is in the X button
//		so for now I am adding a copy here but this needs to be deleted before merging

/// @desc									Finds all nearby layers of the provided layer, deleting
///												the provided layer and the nearby ones
/// @param {String, Id.Layer} layer_id		The layer to search above and below
function find_and_delete_related_layers(layer_id) {
	var all_layers_to_delete = find_neighboring_layers(layer_id)
	delete_layers(all_layers_to_delete, layer_id)
	layer_destroy(layer_id)
}

/// @desc									Finds all of the layers with a depth within LAYER_SEARCH_TOLERANCE 
/// @param {String, Id.Layer} layer_id		The layer to search above and below
/// @returns								True if provided layer is the closest layer to the camera
function find_neighboring_layers (layer_id) {
	var neighboring_layers = []
	
	for(var layer_depth_index = layer_get_depth(layer_id) - LAYER_SEARCH_TOLERANCE; layer_depth_index < layer_get_depth(layer_id) + LAYER_SEARCH_TOLERANCE; layer_depth_index++) {
		var all_layers_at_depth = layer_get_id_at_depth(layer_depth_index)
		if(all_layers_at_depth[0] != -1) {
			neighboring_layers = array_concat(all_layers_at_depth, neighboring_layers)
		}
	}
	return neighboring_layers
}

/// @desc											Deletes all layers provided except the ignored layer
/// @param {Array} all_layers_to_delete				All layer ids to be deleted
/// @param {String, Id.Layer} layer_to_ignore		Layer ID that is ignored in deletion. This is to ensure
///														the function can finish without this object's layer
///														being deleted, but requires the layer to be deleted
///														outside the function
function delete_layers(all_layers_to_delete, layer_to_ignore) {
	for (var layer_index = 0; layer_index < array_length(all_layers_to_delete); layer_index++)
	{
		if(all_layers_to_delete[layer_index] != layer_to_ignore) {
			layer_destroy(all_layers_to_delete[layer_index])
		}
	}	
}
#endregion







/// @desc											Makes the selected or all enemy instances not visible
/// @param {Array<Id.Instance>} sprites_to_hide		All of the instances desired to be no longer visible
function hide_enemy_sprites(sprites_to_hide = []) {
	if(array_length(sprites_to_hide) <= 0) {
		sprites_to_hide = find_allowed_enemies()
	}
	
	for (var enemy_index = 0; enemy_index < array_length(sprites_to_hide); enemy_index++) {
		sprites_to_hide[enemy_index].visible = false
	}
}

/// @desc											Makes the selected or all enemy instances visible
/// @param {Array<Id.Instance>} sprites_to_show		All of the instances desired to be visible
function show_enemy_sprites(sprites_to_show = []) {
	if(array_length(sprites_to_show) <= 0) {
		sprites_to_show = find_allowed_enemies()
	}
	
	for (var enemy_index = 0; enemy_index < array_length(sprites_to_show); enemy_index++) {
		sprites_to_show[enemy_index].visible = true
	}
}

/// @desc									Creates obj_selectable_chara for each enemy that can be targeted
///												by the played attack
function create_defender_selection() {
	var all_allowed_enemies = find_allowed_enemies()

	for(var enemy_index = 0; enemy_index < array_length(all_allowed_enemies); enemy_index++) {
		var sprite = all_allowed_enemies[enemy_index].sprite_index
		instance_create_layer(all_allowed_enemies[enemy_index].x, all_allowed_enemies[enemy_index].y, highlighed_enemies_layer, obj_selectable_chara, {
			sprite_index : sprite,
			chara_instance : all_allowed_enemies[enemy_index]
		})
		all_allowed_enemies[enemy_index].visible = false
	}
	create_back_and_cancel_buttons(false)
}

/// @desc									Finds all obj_enemy instances that can be targeted by an attack
/// @returns								The array of enemies that can be targeted
function find_allowed_enemies() {
	var num_avaliable_enemies = instance_number(obj_enemy)
	var allowed_enemies = array_create(0)
	for(var enemy_index = 0; enemy_index < num_avaliable_enemies; enemy_index++) {
		var enemy_instance = instance_find(obj_enemy, enemy_index)
		array_push(allowed_enemies, enemy_instance)
	}
	return allowed_enemies
}

/// @desc									Draws a rectangle over the whole camera to dim the game
///												NOTE: this must be called in the Draw event or it won't
///												work correctly
function draw_target_selection_background() {
	draw_set_colour(c_black)
	draw_set_alpha(BACKGROUND_ALPHA)
	var default_camera_id = camera_get_default()
	var screen_width = camera_get_view_width(default_camera_id)
	var screen_height = camera_get_view_height(default_camera_id)
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)
}