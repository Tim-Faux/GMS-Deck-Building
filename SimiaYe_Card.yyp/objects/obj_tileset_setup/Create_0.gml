tiles_have_collision = false

/// @desc										Loops through all of the tiles in the given tileset
///													registering their collision bounds in the grid
///													and randomizes the given tile. NOTE: The 
///													tile_to_be_randomized is not automatically added
///													to randomization options
/// @param {String, Id.Layer} layer_name		The layer that the tiles being randomized are on.
///													NOTE: This must be a tile layer with a tile map
/// @param {Real} tile_to_randomize				The position of the tile that should be randomized,
///													likely the first tile in the auto tile template.
///													NOTE: Tiles are numbered left to right top to
///													bottom excluding the top left corner starting at 1
/// @param {Array<Real>} randomization_options	The positions of the tiles that the tile_to_randomize
///													can be randomized into. NOTE: Tiles are numbered
///													left to right top to bottom excluding the top left
///													corner starting at 1
function handle_tile_actions(layer_name, tile_to_randomize, randomization_options) {
	var tilemap_id = layer_tilemap_get_id(layer_name);
	if(tilemap_id == -1) {
		return
	}

	var num_tiles_x = tilemap_get_width(tilemap_id)
	var num_tiles_y = tilemap_get_height(tilemap_id);

	var tile_width = tilemap_get_tile_width(tilemap_id)
	var tile_height = tilemap_get_tile_height(tilemap_id)

	var current_tile_x = 0
	var current_tile_y = 0

	do {
		var tile_current = tilemap_get(tilemap_id, current_tile_x, current_tile_y)
		
		if(tiles_have_collision && instance_exists(obj_pathing_grid)) {
			if(!tile_get_empty(tile_current)) {
				obj_pathing_grid.add_collidable_tile_to_pathing_grid(current_tile_x * tile_width, current_tile_y * tile_height, tile_width - 1, tile_height - 1)
			}
		}

		if (tile_to_randomize >= 0 && array_length(randomization_options) > 1 && 
				tile_current == tile_to_randomize) {
			var tile_selected = irandom(array_length(randomization_options) - 1)
			tilemap_set(tilemap_id, randomization_options[tile_selected], current_tile_x, current_tile_y)
		}
		
		if (current_tile_x >= num_tiles_x) {
			current_tile_x = 0
			if (current_tile_y < num_tiles_y) {
				current_tile_y += 1
			} 
		} 
		else {
			current_tile_x += 1
		}
		
	}
	until (current_tile_x >= num_tiles_x && current_tile_y >= num_tiles_y)	
}