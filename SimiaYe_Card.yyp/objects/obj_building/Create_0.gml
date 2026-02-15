fade_in = false
fade_in_percent = 1

/// @desc							Sets up the shd_see_through shader to cut out a circle in the building
///										texture around the player
/// @param {Id.Instance} player		The player that the cut out is centered around
function see_through_building(player) {
	if(!fade_in) {
		fade_in = true
		fade_in_percent = 0
	}
	var building_uv_data = sprite_get_uvs(sprite_index, 0)
	var building_x_uv_translation = (building_uv_data[2] -  building_uv_data[0]) / sprite_width
	var building_y_uv_translation = (building_uv_data[3] -  building_uv_data[1]) / sprite_width
	
	var player_x_in_uv = (player.x - x) * building_x_uv_translation
	var portrait_uv_center_x = building_uv_data[0] + player_x_in_uv
	
	var player_y_in_uv = (player.y - y) * building_y_uv_translation
	var portrait_uv_center_y = building_uv_data[1] + player_y_in_uv
	
	var player_uv_data = sprite_get_uvs(player.sprite_index, 0)
	var center_circle_uv_radius = 2 / 5 * (player_uv_data[3] - player_uv_data[1])
	
	shader_set(shd_see_through);
	shader_set_uniform_f(shader_get_uniform(shd_see_through, "fadeInPercent"), fade_in_percent)
	shader_set_uniform_f(shader_get_uniform(shd_see_through, "radius"), center_circle_uv_radius)
	shader_set_uniform_f(shader_get_uniform(shd_see_through, "centerPos"), portrait_uv_center_x, portrait_uv_center_y, )
	draw_self()
	shader_reset()
}