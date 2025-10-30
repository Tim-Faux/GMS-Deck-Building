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

/// @desc												Finds all of the characters of the given classes
///															and creates obj_selectable_chara of them
/// @param {Array<Real>} allowed_chara_classes	The classes allowed to attack, defaulting to all_chara
function create_attacker_selection(allowed_chara_classes = [chara_class.all_chara]) {
	var all_allowed_attackers = find_allowed_attackers(allowed_chara_classes)

	for(var chara_index = 0; chara_index < array_length(all_allowed_attackers); chara_index++) {
		//TODO create dimming box
		var sprite = all_allowed_attackers[chara_index].sprite_index
		instance_create_layer(all_allowed_attackers[chara_index].x, all_allowed_attackers[chara_index].y, highlighed_chara_layer, obj_selectable_chara, {
			sprite_index : sprite,
			chara_instance : all_allowed_attackers[chara_index]
		})
		all_allowed_attackers[chara_index].visible = false
	}	
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