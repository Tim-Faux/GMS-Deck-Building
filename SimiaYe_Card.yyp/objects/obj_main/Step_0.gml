event_inherited()
/// @description Insert description here
// You can write your code in this editor

if (arena = false) {
	
	var xmove = keyboard_check(ord("D")) - keyboard_check(ord("A"))
	var ymove = keyboard_check(ord("S")) - keyboard_check(ord("W"))

	//movement momentum
		x = x + (xmove * pspeed);
		y = y + (ymove * pspeed);
		if (place_meeting(x, y, obj_wall)) {
			x -= (xmove * pspeed)
		}
		if (place_meeting(x, y, obj_wall)) {
			y -= (ymove * pspeed);
		}
}
