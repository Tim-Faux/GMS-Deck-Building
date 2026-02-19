for(var item_index = 0; item_index < array_length(all_collision_items); item_index++) {
	if(tile_layer_name == all_collision_items[item_index]) {
		tiles_have_collision = true
		break
	}
}
handle_tile_actions(tile_layer_name, tile_to_be_randomized, randomization_options)