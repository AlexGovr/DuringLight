
uniform vec2 candle_pos;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 original = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float k = 3.0;
	float r = pow(original.r, k);
	float g = pow(original.g, k);
	float b = pow(original.b, 2.0);
	gl_FragColor = vec4(r, g, b, 1);
}
