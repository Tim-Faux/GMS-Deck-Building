var _zwrite = gpu_get_zwriteenable()
var _ztest = gpu_get_ztestenable()
var _alphatest = gpu_get_alphatestenable()
var _depth = gpu_get_depth()
gpu_set_zwriteenable(true)
gpu_set_ztestenable(true)
gpu_set_alphatestenable(true)
gpu_set_depth(depth - bbox_top - 1);

if(variable_global_exists("player_chara") && global.player_chara != noone) {
	var player_above_bbox =			global.player_chara.y + global.player_chara.sprite_height - global.player_chara.sprite_yoffset < bbox_top + 1
	var player_behind_building =	global.player_chara.y + global.player_chara.sprite_height - global.player_chara.sprite_yoffset > y - sprite_yoffset
	var player_in_building_width =	global.player_chara.bbox_left + 1 < bbox_right && global.player_chara.bbox_right - 1 > bbox_left
								
	if(player_above_bbox && player_behind_building && player_in_building_width) {
		see_through_building(global.player_chara)
	}
	else {
		draw_self()
		fade_in = false
	}
}
else {
	draw_self()
}

gpu_set_depth(_depth)
gpu_set_zwriteenable(_zwrite)
gpu_set_ztestenable(_ztest)
gpu_set_alphatestenable(_alphatest)