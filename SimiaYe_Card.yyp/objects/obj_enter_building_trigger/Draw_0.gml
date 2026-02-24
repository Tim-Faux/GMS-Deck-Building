if(player_in_range && global.player_chara.bbox_bottom > bbox_top) {
	draw_set_colour(c_white)
	draw_set_font(fnt_interactable)
	draw_trigger_interact_icon()
	draw_set_colour(c_white)
}