if(instance_number(obj_pathing_grid) > 1) {
	instance_destroy()	
}
grid_being_created = false

/// @desc						Creates an mp_grid based on the player character bbox and assignes it 
///									to global.pathing_grid
/// @returns {Bool}				True if the grid was created successfully and false if not
function create_room_grid() {
	if(grid_being_created) {
		return false
	}
	grid_being_created = true
	var cell_width = room_height / 32
	var cell_height = room_height / 32
	for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
		var chara_instance = instance_find(obj_player, chara_index)
		if(chara_instance.is_controlled_chara) {
			cell_width = round((chara_instance.bbox_right - chara_instance.bbox_left) / 2)
			cell_height = round((chara_instance.bbox_bottom - chara_instance.bbox_top) / 2)
			break
		}
	}
		
	global.pathing_grid = mp_grid_create(0, 0, ceil(room_width / cell_width), ceil(room_height / cell_height), cell_width, cell_height)
	grid_being_created = false
	return true
}

/// @desc						Destroys the current global.pathing_grid to avoid memory leaks
function delete_room_grid() {
	if(!grid_being_created) {
		mp_grid_destroy(global.pathing_grid)
	}
}

/// @desc						Finds the collidable items in the current room and mark their 
///									grid tiles forbidden
function add_collidable_items_to_grid() {
	if(!variable_global_exists("pathing_grid") || global.pathing_grid == -1) {
		var grid_created = create_room_grid()
		if(!grid_created)
			return
	}
	
	var collidable_items = find_room_collision_items(room)
	for(var item_index = 0; item_index < array_length(collidable_items); item_index++) {
		if(typeof(collidable_items[item_index]) == "ref") {
			mp_grid_add_instances(global.pathing_grid, collidable_items[item_index], false)	
		}
	}	
}

/// @desc						Uses the given information to mark the required grid tiles forbidden
/// @param {Real} tile_x		The x coord in the room of the tile
/// @param {Real} tile_y		The y coord in the room of the tile
/// @param {Real} tile_width	The width of the tile
/// @param {Real} tile_height	The height of the tile
function add_collidable_tile_to_pathing_grid(tile_x, tile_y, tile_width, tile_height) {
	if(!variable_global_exists("pathing_grid") || global.pathing_grid == -1) {
		var grid_created = create_room_grid()
		if(!grid_created)
			return
	}
	mp_grid_add_rectangle(global.pathing_grid, tile_x, tile_y, tile_x + tile_width, tile_y + tile_height)
}