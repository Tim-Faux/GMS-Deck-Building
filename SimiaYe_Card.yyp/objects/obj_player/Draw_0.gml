draw_self()

if(character_teleporting) {
	draw_sprite(teleport_sprite, teleport_effect_subimage, x, y)
	scale_sprite_for_teleport()
}
