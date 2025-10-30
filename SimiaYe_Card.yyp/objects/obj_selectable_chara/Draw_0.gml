draw_character_highlight()

if(chara_clicked) {
	image_xscale *= 0.9
	image_yscale *= 0.9
}
draw_self()
image_xscale = starting_image_x_scale
image_yscale = starting_image_y_scale

if(is_selected) {
	draw_arrow_overhead()
}