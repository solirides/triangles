shader_type canvas_item;

uniform float randomness = 0.2;
uniform float luminosity_offset = 0.0;
uniform sampler2D GRADIENT: source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

float random (vec2 uv) {
	return fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123);
}

float luminosity(vec4 color) {
	return sqrt(0.299*pow(color.r,2) + 0.587*pow(color.g,2) + 0.114*pow(color.b,2));
}

void fragment() {
	// Called for every pixel the material is visible on.
	float l = luminosity(texture(SCREEN_TEXTURE, SCREEN_UV)) + randomness*random(SCREEN_UV) + luminosity_offset;
	vec4 color = texture(GRADIENT, vec2(l,0));
	COLOR = color;
}



//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
