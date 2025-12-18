draw_self()

if(character_teleporting) {
	if(image_index >= image_number - 1) {
		image_speed = -1
		x = target_pos.x
		y = target_pos.y
	}
	else if (image_speed == -1 && image_index < 1)
	{
		sprite_index = stand_still_sprite;
		image_speed = 1;
		character_teleporting = false
	}
}