//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float page_angle;
uniform sampler2D page_back;

void main()
{
	if(page_angle < 0.0) {
		gl_FragColor = v_vColour * texture2D( page_back, v_vTexcoord );
	}
	else {
		gl_FragColor = v_vColour * texture2D( gm_BaseTexture,  v_vTexcoord);
	}
}
