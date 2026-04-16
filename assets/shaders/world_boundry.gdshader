shader_type canvas_item;

uniform float scale = 0.02;
uniform float luminosity_offset = 0.0;
uniform sampler2D GRADIENT: source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
varying vec2 global_coords;

vec2 random(vec2 uv){
	uv = vec2( dot(uv, vec2(127.1,311.7) ),
			dot(uv, vec2(269.5,183.3) ) );
	return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);
	vec2 blur = smoothstep(0.0, 1.0, uv_fract);
	
	return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
					dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
				mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
					dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void vertex() {
	global_coords = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment() {
	float a = noise(global_coords * scale);
	vec4 color = texture(GRADIENT, vec2(a,0));
	COLOR = color;
}
