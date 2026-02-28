/// @desc										Loops through all non-excluded layers and checks which
///													depth isthe highest.
/// @param {Array<Id.Layer>} excluded_layers	The optional array that exclues certain layers from having
///													their depth compared. These layers will not be returned
/// @returns {Id.Layer}							The layer which is the closest to the camera
function find_top_layer (excluded_layers = []) {
	var all_layers = layer_get_all()
	var top_layer_id = all_layers[0]
	for (var layer_index = 1; layer_index < array_length(all_layers); layer_index++) {
		if(!array_contains(excluded_layers, all_layers[layer_index]) &&
				layer_get_depth(all_layers[layer_index]) < layer_get_depth(top_layer_id)) {
			top_layer_id = all_layers[layer_index]
		}
	}
	return top_layer_id
}