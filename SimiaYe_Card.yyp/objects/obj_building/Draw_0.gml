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