/*
225, 176, 91 to 255, 205, 67
198, 142, 80 to 255, 182, 67
110, 78, 154 to 222, 60, 138
*/

shader_type canvas_item;
uniform float shirt_vibrance: hint_range(0f, 1f);


void fragment() {
	if(texture(TEXTURE, UV).a > 0.0) {
		vec3 cur_color = texture(TEXTURE, UV).rgb;
		if(length(cur_color - vec3(255f/255f, 176f/255f, 91f/255f)) < 0.15) {
			COLOR.rgb = mix(cur_color, vec3(255f/255f, 205f/255f, 67f/255f), shirt_vibrance);
		} else if(length(cur_color - vec3(198f/255f, 142f/255f, 80f/255f)) < 0.1) {
			COLOR.rgb = mix(cur_color, vec3(255f/255f, 182f/255f, 67f/255f), shirt_vibrance);
		} else if(length(cur_color - vec3(110f/255f, 78f/255f, 154f/255f)) < 0.15) {
			COLOR.rgb = mix(cur_color, vec3(222f/255f, 60f/255f, 138f/255f), shirt_vibrance);
		} else {
			COLOR.rgb = cur_color;
		}
	} else {
		COLOR = vec4(0f, 0f, 0f, 0f)
	}
}