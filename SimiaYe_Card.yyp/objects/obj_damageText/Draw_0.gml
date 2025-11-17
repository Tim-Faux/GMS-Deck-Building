/// @desc							Sets up and displays the damage text 
/// @param  {Asset} text_font		The font used while displaying the damage
///			{Colour} text_color		The color of the damage text
///			{String} damage_taken	The damage amount applied
draw_set_font(text_font)
draw_set_color(text_color)
depth = -1

draw_text(x-10, y-12, damage_taken)