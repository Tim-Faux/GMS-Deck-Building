#macro HEALTH_BAR_HEALTH_PADDING 2
#macro HEALTH_CHANGE_SMOOTHING 0.03

target_health_x_scale = 1
find_chara_health_x_scale()
current_health_x_scale = target_health_x_scale
health_surface = -1

/// @desc								Calculates how much the character's health bar should be shrunk
///											based on how much of their max health they currently have
function find_chara_health_x_scale() {
	if(associated_chara != noone && instance_number(associated_chara) > 0) {
		var chara_instance = instance_find(associated_chara, 0)
		target_health_x_scale = clamp(chara_instance.player_current_health / chara_instance.player_max_health, 0, 1)
	}
}

/// @desc								Draws the character's health bar, scaled to fit in the background
///											and scaled based on their health_x_scale
function draw_health_bar_health() {
	if !(surface_exists(health_surface))
	{
	    health_surface = surface_create(sprite_width, sprite_height)
	}
	surface_set_target(health_surface)
	draw_clear_alpha(c_black, 0)
	
	if(current_health_x_scale > 0 && current_health_x_scale > target_health_x_scale)
		current_health_x_scale = clamp(current_health_x_scale - HEALTH_CHANGE_SMOOTHING, target_health_x_scale, current_health_x_scale)
	draw_sprite_ext(spr_health_bar_health, 0, 0, 0, current_health_x_scale, 1, 0, c_white, 1)
	surface_reset_target()

	var health_x_pos = x + (HEALTH_BAR_HEALTH_PADDING * image_xscale)
	var health_y_pos = y + (sprite_height - (sprite_get_height(spr_health_bar_health) * image_yscale)) / 2
	draw_surface_ext(health_surface, health_x_pos, health_y_pos, image_xscale, image_yscale, image_angle, c_white, 1)
}