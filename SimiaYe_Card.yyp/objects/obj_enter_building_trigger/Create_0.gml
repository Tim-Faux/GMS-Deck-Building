#macro TRIGGER_INTERACT_ICON_RADIUS 10

// Inherit the parent event
event_inherited();

player_in_range = false

/// @desc							Wakes up this trigger so that the player can interact with it
///										to move to the associated room
function wake_up(player_chara) {
	player_in_range = true
	player_chara = player_chara
}

/// @desc							Draws the icon for the player's interact button as well as a
///										triangle and circle for it's background
function draw_trigger_interact_icon() {
	var x_pos = x + sprite_width
	var y_pos = y - (2 * TRIGGER_INTERACT_ICON_RADIUS)
	var interact_icon = InputIconGet(INPUT_VERB.INTERACT)
	var circle_center_x = x_pos + (string_width(interact_icon) / 2)
	var circle_center_y = y_pos + (string_height(interact_icon) / 2)
	
	draw_circle(circle_center_x, circle_center_y, TRIGGER_INTERACT_ICON_RADIUS, false)
	draw_triangle(	circle_center_x - TRIGGER_INTERACT_ICON_RADIUS,
					circle_center_y, 
					circle_center_x,
					circle_center_y + TRIGGER_INTERACT_ICON_RADIUS,
					circle_center_x - TRIGGER_INTERACT_ICON_RADIUS,
					circle_center_y + TRIGGER_INTERACT_ICON_RADIUS,
					false)
					
	draw_set_colour(c_black)
	draw_text(x_pos,  y_pos, interact_icon)
}