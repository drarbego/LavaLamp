shader_type canvas_item;
uniform float threshold = 0.15;
uniform vec4 background_edge: hint_color;
uniform vec4 background_center: hint_color;

uniform float max_strength = 5.0;

uniform float top = 0.2;
uniform float bottom = 0.5;

uniform vec4 blob_top: hint_color;
uniform vec4 blob_bottom: hint_color;

float oscilate(float x, float speed, float offset) {
	return pow(sin(x * speed + offset), 2) * (bottom - top) + top;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	//COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	if (COLOR.r >= 0.7 && COLOR.b >= 0.7) {
		float background_color_proportion = distance(vec2(0.5, 0.5) / TEXTURE_PIXEL_SIZE, UV / TEXTURE_PIXEL_SIZE) / (0.5 / TEXTURE_PIXEL_SIZE.x);
		COLOR = mix(background_center, background_edge, background_color_proportion);
		//COLOR = mix(background_center, background_edge, abs(0.5 - UV.x) * 2.0);

	    vec3 blob_centers[6];
	    blob_centers[0] = vec3(0.4, oscilate(TIME, 0.1, 0.3), 0.8);
	    blob_centers[1] = vec3(0.45, oscilate(TIME, 0.15, 0.45), 0.6);
		blob_centers[2] = vec3(0.5, oscilate(TIME, 0.3, 0.5), 0.8);
		blob_centers[3] = vec3(0.55, oscilate(TIME, 0.45, 0.6), 0.6);
		blob_centers[4] = vec3(0.6, oscilate(TIME, 0.4, 0.5), 0.8);
		blob_centers[5] = vec3(0.65, oscilate(TIME, 0.3, 0.45), 0.6);
	    float influence = 0.0;
	    for (int i = 0; i < blob_centers.length(); i++) {
	        float distance_to_blob_center = distance(blob_centers[i].xy / TEXTURE_PIXEL_SIZE, UV / TEXTURE_PIXEL_SIZE);
			influence += blob_centers[i].z * max_strength * (1.0 / distance_to_blob_center);
	    }
		
		vec4 current_blob_color = mix(blob_top, blob_bottom, (UV.y - top) / (bottom - top));
		float glow_multiplier = threshold * 10.0;
		COLOR = mix(COLOR, current_blob_color, pow(glow_multiplier * influence, 0.75));
		if (influence > threshold) {
			COLOR = current_blob_color;
		}
	}
}