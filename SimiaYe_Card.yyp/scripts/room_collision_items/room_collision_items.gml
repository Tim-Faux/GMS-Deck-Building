/// If any item have collision with the player they should be placed in this list
/// NOTE: Please use parent objects when possible here to keep things organized
#macro all_collision_items [ obj_brick, "walls" ]

/// @desc													Finds all the objects in the given room that
///																can be collided with
/// @param {Asset.GMRoom}									The room index to find collision objects for
/// @returns {Array<Id.TileMapElement, Asset.GMObject>}		An array of all objects that can be collided
///																with in the given room
function find_room_collision_items(room_index) {
	var collision_items_in_room = []
	var room_data = room_get_info(room_index, false, true, true, true, false)
	for (var item_index = 0; item_index < array_length(all_collision_items); item_index++) {
		var collidable_item = noone
		if(typeof(all_collision_items[item_index]) == "ref") {
			collidable_item = find_instance_collision_items(room_data, all_collision_items[item_index])
		}
		else if(typeof(all_collision_items[item_index]) == "string") {
			collidable_item = find_layer_collision_items(room_data, all_collision_items[item_index])
		}
			
		if(collidable_item != noone) {
			array_push(collision_items_in_room, collidable_item)
		}
	}
	return collision_items_in_room
}

/// @desc										Searches through the room data to find if any of the instances
///													have the given object_index
/// @param {Struct} room_data					The struct returned from room_get_info
/// @param {Asset.GMObject} collidable_object	The object index of an object with collision
/// @returns {Asset.GMObject}					If this object is found the object index is returned,
///													otherwise noone is returned
function find_instance_collision_items(room_data, collidable_object) {
	for(var instance_data_index = 0; instance_data_index < array_length(room_data.instances); instance_data_index++) {
		var room_object_index = room_data.instances[instance_data_index][$ "object_index"]
		if(asset_get_index(room_object_index) == collidable_object) {
			return collidable_object
		}
	}
	return noone
}

/// @desc							Searches through the room data to find if any of the layers have
///										the given name, then finds the data needed for the collision
/// @param {Struct} room_data		The struct returned from room_get_info
/// @param {String} layer_name		The layer name of a tile map the player can't pass through
/// @returns {Id.TileMapElement}	The tile map element id used to check for collisions
function find_layer_collision_items(room_data, layer_name) {
	for(var layer_data_index = 0; layer_data_index < array_length(room_data.layers); layer_data_index++) {
		var room_layer_name = room_data.layers[layer_data_index][$ "name"]
		if(room_layer_name == layer_name) {
			var room_layer_elements = room_data.layers[layer_data_index][$ "elements"]
			for(var element_index = 0; element_index < array_length(room_layer_elements); element_index++) {
				if(room_layer_elements[element_index][$ "type"] == layerelementtype_tilemap) {
					return layer_tilemap_get_id(layer_name)
				}
			}
		}
	}
	return noone
}