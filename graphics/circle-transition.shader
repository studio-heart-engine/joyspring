shader_type canvas_item;

uniform sampler2D mask;
uniform float cutoff: hint_range(0f, 1f);
uniform float smooth_size: hint_range(0f, 1f);

void fragment() {
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff + smooth_size, cutoff, value * (1f - smooth_size) + smooth_size);
	COLOR = vec4(COLOR.rgb, alpha);
}