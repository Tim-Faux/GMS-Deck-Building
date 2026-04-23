//
// Determines the pixel's alpha based on it's distance from the center coords
// If it's greater than the given radius (iClipData.z) then it is 0 otherwise it's determined by v_vColour
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 iResolution;
uniform vec3 iClipData;

void main()
{
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	vec2 center = vec2(iClipData.x, iClipData.y);
	vec2 aspect = vec2(1.0, iResolution.y / iResolution.x);
	gl_FragColor.a *= step(length((v_vTexcoord - center) * aspect), iClipData.z);
}
