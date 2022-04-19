//
// Simple passthrough fragment shader
//
const int light_steps = 3;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_aspect_ratio;
uniform float u_radiuses[light_steps];
uniform float u_brightness[light_steps+1];
uniform float u_blue_add[light_steps+1];

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

float dist(vec2 v1, vec2 v2) {
    return sqrt(pow(abs(v1.x - v2.x) * u_aspect_ratio, 2.0) + pow(abs(v1.y - v2.y), 2.0));
}

float multy_step(
		float d, 
		float v1[light_steps], 
		float v2[light_steps+1]) {
	for(int i=0; i<light_steps; i++) {
		if (d > v1[i])
			return v2[i];
	}
	return v2[light_steps];
}

vec4 lighting(vec4 col, vec2 pos) {
	float d = dist(pos, u_mouse);
	float br = multy_step(d, u_radiuses, u_brightness);
	float b = col.b + (1.0 - col.b) * (multy_step(d, u_radiuses, u_blue_add));
	vec3 _col = vec3(col.r, col.g, b) * br;
	return vec4(_col, col.a);
}

void main() {
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	vec2 pos = gl_FragCoord.xy/u_resolution;
	gl_FragColor = lighting(col, pos);
}