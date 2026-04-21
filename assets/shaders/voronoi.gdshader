shader_type canvas_item;

uniform float scale = 0.01;
uniform vec4 color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D GRADIENT: source_color;
uniform float time_scale = 0.3;
varying vec2 global_coords;

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	vec2 minimum_point;
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			
			//if (diff.x > 0.0) {
					//minimum_dist = dist;
					//minimum_point = point;
				//}
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				if (diff.x > 0.0) {
					minimum_dist = dist;
					minimum_point = point;
				}
			}
		}
	}
	
	return minimum_dist;
	//return minimum_point.x;
}

vec2 voronoi(vec2 uv, float columns, float rows, float time) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	vec2 minimum_point;

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			point = vec2( cos(time * point.x), sin(time * point.y) ) * 0.5 + 0.5;
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				minimum_point = point;
			}
		}
	}
	return minimum_point;
}

void vertex() {
	global_coords = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment() {
	float voronoi = voronoi(global_coords * scale, 5.0, 5.0, TIME * time_scale + 100.0).r;
	//float worley = worley(global_coords * scale, 5.0, 5.0);
	//COLOR = vec4(voronoi, 1.0);
	//vec3 voronoi = vec3(voronoi(UV, 10.0, 5.0).r);
	//COLOR = vec4(voronoi, 1.0);
	
	COLOR = color * voronoi;
	COLOR = texture(GRADIENT, vec2(voronoi,0));;
	//COLOR =  COLOR * voronoi;
}
