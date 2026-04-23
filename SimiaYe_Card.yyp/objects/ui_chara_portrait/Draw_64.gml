shader_set(shd_clip);

shader_set_uniform_f(shader_get_uniform(shd_clip, "iResolution"), center_circle_width, center_circle_height)
shader_set_uniform_f(shader_get_uniform(shd_clip, "iClipData"), portrait_uv_center_x, portrait_uv_center_y, center_circle_uv_radius)
draw_sprite_ext(portrait_sprite, 0, x, portrait_y_pos, sprite_x_scale, sprite_y_scale, 0, c_white, 1)
shader_reset()

draw_self()