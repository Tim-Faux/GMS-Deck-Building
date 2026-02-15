//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float fadeInPercent;
uniform float radius;
uniform vec2 centerPos;

void main()
{
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	if(fadeInPercent > 0.0) {
		float distFromCenter = (length(v_vTexcoord - centerPos) / fadeInPercent) - radius;
		gl_FragColor.a *= distFromCenter / (2.0 / 5.0 * radius);
	}
}