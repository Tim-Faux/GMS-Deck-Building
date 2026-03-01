attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 page_vertex_data;
uniform vec2 page_flip_data;

void main()
{
	float _x = page_vertex_data.x;
	float _y = page_vertex_data.y + in_Position.y * page_vertex_data.z;
	
	float _start_y = _y;
	float _page_angel = page_flip_data.x;
	
	for(int i = 0; i < int(in_Position.x); i++) {
		_page_angel += page_flip_data.y;
		_x += cos(_page_angel) * page_vertex_data.w;
		_y += -sin(_page_angel) * page_vertex_data.w;
	}
	
    vec4 object_space_pos = vec4( _x, _y, _y - _start_y, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
	v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
