var _zwrite = gpu_get_zwriteenable()
var _ztest = gpu_get_ztestenable()
var _alphatest = gpu_get_alphatestenable()
gpu_set_zwriteenable(true)
gpu_set_ztestenable(true)
gpu_set_alphatestenable(true)
var _depth = gpu_get_depth()

gpu_set_depth(depth - bbox_top - 1);

var player = instance_find(obj_player, 0)
var player_above_bbox =			player.y + player.sprite_height - player.sprite_yoffset < bbox_top + 1
var player_behind_building =	player.y + player.sprite_height - player.sprite_yoffset > y - sprite_yoffset
var player_in_building_width =	player.bbox_left + 1 < bbox_right && player.bbox_right - 1 > bbox_left
								
if(player_above_bbox && player_behind_building && player_in_building_width) {
	see_through_building(player)
}
else {
	draw_self()
	fade_in = false
}

gpu_set_depth(_depth)
gpu_set_zwriteenable(_zwrite)
gpu_set_ztestenable(_ztest)
gpu_set_alphatestenable(_alphatest)