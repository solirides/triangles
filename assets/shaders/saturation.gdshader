shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable;
uniform float saturation : hint_range(0.0, 3.0) = 1.0;

float luminosity(vec4 color) {
	return sqrt(0.299*pow(color.r,2) + 0.587*pow(color.g,2) + 0.114*pow(color.b,2));
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	
	float lum = luminosity(color);
	vec3 new_color = mix(vec3(lum), color.rgb, saturation);
	
	COLOR = vec4(new_color, color.a);
}
