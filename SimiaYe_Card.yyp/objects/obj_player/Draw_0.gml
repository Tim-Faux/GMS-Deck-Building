var _zwrite = gpu_get_zwriteenable()
var _ztest = gpu_get_ztestenable()
var _alphatest = gpu_get_alphatestenable()
var _depth = gpu_get_depth()
gpu_set_zwriteenable(true)
gpu_set_ztestenable(true)
gpu_set_alphatestenable(true)

gpu_set_depth(depth - (y + sprite_height - sprite_yoffset))
draw_self()

gpu_set_depth(_depth)
gpu_set_zwriteenable(_zwrite)
gpu_set_ztestenable(_ztest)
gpu_set_alphatestenable(_alphatest)

if(character_teleporting) {
	draw_sprite(teleport_sprite, teleport_effect_subimage, x, y)
	scale_sprite_for_teleport()
}
