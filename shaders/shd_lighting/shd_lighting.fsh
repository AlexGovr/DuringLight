
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 original = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float r = original.r;
	float g = original.g;
	float b = original.b;
	gl_FragColor = vec4(r*0.75, g*0.75, b, 1);
}
