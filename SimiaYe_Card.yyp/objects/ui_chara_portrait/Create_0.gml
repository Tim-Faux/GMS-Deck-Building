#macro PORTRIAT_BORDER_BOTTOM_WIDTH 5
#macro PORTRIAT_BORDER_TOP_WIDTH 21
#macro PORTRIAT_BORDER_LEFT_WIDTH 5
#macro PORTRIAT_BORDER_RIGHT_WIDTH 20
#macro PORTRAIT_CIRCLE_RADIUS_PADDING 2

center_circle_width = sprite_get_width(sprite_index) - PORTRIAT_BORDER_LEFT_WIDTH - PORTRIAT_BORDER_RIGHT_WIDTH
center_circle_height = sprite_get_height(sprite_index) - PORTRIAT_BORDER_BOTTOM_WIDTH - PORTRIAT_BORDER_TOP_WIDTH
sprite_x_scale = image_xscale
sprite_y_scale = image_yscale
set_sprite_scale()
portrait_y_pos = set_portrait_y_pos()
center_circle_uv_radius = 0
portrait_uv_center_x = 0
portrait_uv_center_y = 0
find_shader_data()

/// @desc								Finds the position of the portrait_sprite so that the bottom of
///											the portrait is touching the bottom of the inner circle.
///											NOTE: This assumes the portrait's origin is set to "top center"
/// @returns {Real}						The y position to place the portrait at
function set_portrait_y_pos() {
	var sprite_bottom = y - sprite_yoffset + sprite_height - (PORTRIAT_BORDER_BOTTOM_WIDTH * image_yscale)
	var chara_portrait_scaled_size = sprite_get_height(portrait_sprite) * sprite_y_scale
	return sprite_bottom - chara_portrait_scaled_size
}

/// @desc								Finds and sets the sprite_x_scale and sprite_y_scale so that it
///											will fit in the circle but is not greater than image scales
function set_sprite_scale() {
	sprite_y_scale = clamp((center_circle_height * image_yscale) / sprite_get_height(portrait_sprite), 0, image_yscale)
	sprite_x_scale = clamp((center_circle_width * image_xscale) / sprite_get_width(portrait_sprite), 0, image_xscale)
}

/// @desc								Calculates the number that when multipled by a horizontal distance
///											in pixel coordinates will give the equivalent in uv coordinates
/// @param {Asset.GMSprite}				The Sprite to find the conversion factor for
/// @returns {Real}						The number to multiply a horizontal pixel distance by to get the
///											equivalent uv distance
function convert_pixel_width_to_uvs_factor(sprite) {
	var _uv_data = sprite_get_uvs(sprite, 0);
	var _umin = _uv_data[0],
	_umax = _uv_data[2]

	return (_umax - _umin) / sprite_get_width(sprite)
}

/// @desc								Calculates the number that when multipled by a vertical distance 
///											in pixel coordinates will give the equivalent in uv coordinates
/// @param {Asset.GMSprite}				The Sprite to find the conversion factor for
/// @returns {Real}						The number to multiply a vertical pixel distance by to get the 
///											equivalent uv distance
function convert_pixel_height_to_uvs_factor(sprite) {
	var _uv_data = sprite_get_uvs(sprite, 0);
	var _vmin = _uv_data[1],
	_vmax = _uv_data[3]

	return (_vmin - _vmax) / sprite_get_height(sprite)
}

/// @desc								Calculates the center_circle_uv_radius, portrait_uv_center_x,
///											and portrait_uv_center_y of the portrait circle and 
///											portrait_sprite
function find_shader_data() {
	var center_uv_radius = ((center_circle_width + PORTRAIT_CIRCLE_RADIUS_PADDING) / 2) *
								convert_pixel_width_to_uvs_factor(sprite_index)
	var circle_to_portrait_scale_ratio = image_xscale / sprite_x_scale
	center_circle_uv_radius = center_uv_radius * circle_to_portrait_scale_ratio
	
	var _uv_data = sprite_get_uvs(portrait_sprite, 0)
	var _umin = _uv_data[0],
		_vmin = _uv_data[1],
		_umax = _uv_data[2],
		_vmax = _uv_data[3]
	portrait_uv_center_x = _umin + ((_umax - _umin) / 2)
	portrait_uv_center_y = _vmax - center_circle_uv_radius
}