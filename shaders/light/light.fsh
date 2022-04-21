//
// Simple passthrough fragment shader
//

const int steps = 3;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_aspect_ratio;
uniform float u_raduises[steps];
uniform float u_brightness[steps];
uniform float u_blue_arr[steps];


varying vec2 v_vTexcoord;
varying vec4 v_vColour;

float dist(vec2 v1, vec2 v2) {
    return sqrt(pow(abs(v1.x - v2.x) * u_aspect_ratio, 2.0) + pow(abs(v1.y - v2.y), 2.0));
}

float bright(float d) {
	d *= 2.0;
	if (d < 0.99)
		return pow(1.0 - d, 0.5);
	return pow(0.01, 0.5);
}

vec4 lighting(vec4 col, vec2 pos) {
	float d = dist(pos, u_mouse);
	float b = col.b + (1.0 - col.b) * pow(d, 0.5);
	vec3 _col = vec3(col.r, col.g, b) * bright(d);
	return vec4(_col, col.a);
}

void main() {
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	vec2 pos = gl_FragCoord.xy/u_resolution;
	gl_FragColor = lighting(col, pos);
}