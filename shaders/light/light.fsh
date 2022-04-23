
const int steps = 3;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_aspect_ratio;
uniform float u_radiuses[steps];
uniform float u_brightness[steps + 1];
uniform float u_blue_add[steps + 1];


varying vec2 v_vTexcoord;
varying vec4 v_vColour;

float dist(vec2 v1, vec2 v2) {
    return sqrt(pow(abs(v1.x - v2.x) * u_aspect_ratio, 2.0) + pow(abs(v1.y - v2.y), 2.0));
}

float bright(float d) {
	for(int i=0; i<steps; ++i) {
		if(d > u_radiuses[i]) {
			return u_brightness[i];
		}
	}
	return u_brightness[steps];
}

float blue(float d) {
	for(int i=0; i<steps; ++i) {
		if(d > u_radiuses[i]) {
			return u_blue_add[i];
		}
	}
	return u_blue_add[steps];
}

vec4 lighting(vec4 col, vec2 pos) {
	float d = dist(pos, u_mouse);
	float b = blue(d);
	vec3 _col = vec3(col.r, col.g, b) * bright(d);
	return vec4(_col, col.a);
}

void main() {
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
	vec2 pos = gl_FragCoord.xy/u_resolution;
	gl_FragColor = lighting(col, pos);
}