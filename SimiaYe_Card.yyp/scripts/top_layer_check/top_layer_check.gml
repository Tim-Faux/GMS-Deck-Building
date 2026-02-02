/// @desc									Finds the ids of the layers defined in layers_to_ignore
/// @returns {Array<Id.Layer>}				The list of layer ids that should be ignored if they are the
///												top layer
function find_layer_ids_to_ignore() {
	var layers_to_ignore = ["chara_ui"]
	
	var layer_ids_to_ignore = array_create(array_length(layers_to_ignore))
	for(var ignored_layer_index = 0; ignored_layer_index < array_length(layers_to_ignore); ignored_layer_index++) {
		layer_ids_to_ignore[ignored_layer_index] = layer_get_id(layers_to_ignore[ignored_layer_index])
	}
	return layer_ids_to_ignore
}

/// @desc									Checks if the provided layer is the top layer the player clicked on
///												NOTE: This has a buffer of 10 depth for easier UI manipulation
///												but still checks if an object is on top. new layers are assumed
///												to be at least 100 away from eachother to be considered seperate
/// @param {String, Id.Layer} layer_id		Your current layer (should just be able to use "layer")
/// @returns {Boolean}						True if provided layer is the closest layer to the camera
function is_top_layer(layer_id, check_pos_x = -1, check_pos_y = -1){
	var all_layers = layer_get_all()
	var layer_ids_to_ignore = find_layer_ids_to_ignore()
	var layer_above_exists = false
	var selected_layer_depth = (layer_get_depth(layer_id) - 10)
	for(var layer_index = 0; layer_index < array_length(all_layers); layer_index++) {
		if(selected_layer_depth > layer_get_depth(all_layers[layer_index])) {
			if(layer_id != all_layers[layer_index] && 
					array_contains(layer_ids_to_ignore, all_layers[layer_index])) {
				var instance_ids = get_instance_ids(all_layers[layer_index])
				var object_above = collision_point(check_pos_x, check_pos_y, instance_ids, false, true)
				if(object_above != noone) {
					layer_above_exists = true
					break
				}
				else {
					continue	
				}

			}
			else {
				layer_above_exists = true
				break;
			}
		}
		else if (layer_get_depth(layer_id) > layer_get_depth(all_layers[layer_index]) &&
					layer_get_depth(all_layers[layer_index]) >= selected_layer_depth &&
					check_pos_x != -1 && check_pos_y != -1) { 
			var instance_ids = get_instance_ids(all_layers[layer_index])
			var object_above = collision_point(check_pos_x, check_pos_y, instance_ids, false, true)
			if(object_above != noone) {
				layer_above_exists = true;
				break;
			}
		}
	}
	return !layer_above_exists
}

/// @desc									Finds the instance ids of all elements in the given layer
/// @param {String, Id.Layer} layer_id		The layer id of the layer to get the instance ids of
function get_instance_ids(layer_id) {
	var element_ids_in_layer = layer_get_all_elements(layer_id)
	var instance_ids = array_create(array_length(element_ids_in_layer))
	for(var element_id = 0; element_id < array_length(element_ids_in_layer); element_id++) {
		instance_ids[element_id] = layer_instance_get_instance(element_ids_in_layer[element_id]);
	}
	return instance_ids
}