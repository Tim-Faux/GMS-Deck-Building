#macro LAYER_SEARCH_TOLERANCE 10

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