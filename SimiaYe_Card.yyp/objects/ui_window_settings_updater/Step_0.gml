if (step_number == 0) {
	if(anti_aliasing == -1)
		anti_aliasing = display_aa
	
	if(!variable_global_exists("vsync_enabled"))
		global.vsync_enabled = true
	if(vsync_changed)
		global.vsync_enabled = !global.vsync_enabled
	
	display_reset(anti_aliasing, global.vsync_enabled); 
}
    
else if(step_number == 1 && screen_width != -1 && screen_height != -1) {
	window_set_size(screen_width, screen_height); 
	window_center()
}

else if(step_number == 2 && fullscreen_changed) {
	var fullscreen = window_get_fullscreen() ^^ fullscreen_changed
	window_set_fullscreen(fullscreen); 
}

else if(step_number == 3) {
	var accept_resolution_layer = layer_create(depth - 100, "accept_resolution_layer")
	var layer_outline = fx_create("_filter_outline")
	fx_set_parameter(layer_outline, "g_OutlineColour", [1, 0, 0, 1]);
	fx_set_parameter(layer_outline, "g_OutlineRadius", 10);
	instance_create_layer(x, y, accept_resolution_layer, ui_accept_resolution_changes)
}

if (step_number < 4) {
	step_number++;
}