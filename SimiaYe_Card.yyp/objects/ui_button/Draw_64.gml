#macro TEXT_BORDER_BUFFER 10

draw_self()

draw_set_font(font)

if(image_blend == c_white || image_blend == -1) {
	draw_set_colour(text_color)
}
else {
	var blend_adjusted_text_color = merge_colour(text_color, image_blend, 0.5)
	draw_set_colour(blend_adjusted_text_color)
}

draw_set_halign(fa_center)
draw_set_valign(fa_middle)

var text_width = string_width(button_text);
var text_size_scale = 1;
if ((sprite_width - TEXT_BORDER_BUFFER) > 0 && text_width > (sprite_width - TEXT_BORDER_BUFFER)) {
    text_size_scale = (sprite_width - TEXT_BORDER_BUFFER) / text_width;
}
draw_text_transformed(x, y, button_text, text_size_scale, text_size_scale, 0);

draw_set_halign(fa_left)
draw_set_valign(fa_top)