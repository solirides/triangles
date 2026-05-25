shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(1,1,1,1);
uniform vec4 color2 : source_color = vec4(0,0,0,1);
uniform float threshold = 0.4;
uniform vec2 scale = vec2(0.1,0.1);
uniform float time_scale = 30;

void vertex() {
	
}

void fragment() {
	vec4 color = vec4(0,0,0,1);
	color = color2;
	
	
	float a = (UV.x + TIME*time_scale)*scale.x + UV.y*scale.y;
	//float b = 0.2*sin(VERTEX.x*scale.x * TIME*time_scale);
	//float c = 0.3*cos(VERTEX.y*scale.y * TIME*time_scale);
	
	if (fract(a) > threshold) {
		color = color1;
	}
	
	COLOR = color;
}
