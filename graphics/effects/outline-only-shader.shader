shader_type canvas_item;
render_mode unshaded;

uniform vec4 outline_color : hint_color;

void fragment() {
	vec2 pixel_size = vec2(1f, 1f) / vec2(textureSize(TEXTURE, 0));
	if(texture(TEXTURE, UV).a > 0f) {
		COLOR = vec4(0, 0, 0 ,0)
	} else {
		float alpha = 0f;
		alpha += texture(TEXTURE, UV + vec2(pixel_size.x, 0)).a;
		alpha += texture(TEXTURE, UV + vec2(-pixel_size.x, 0)).a;
		alpha += texture(TEXTURE, UV + vec2(0, pixel_size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(0, -pixel_size.y)).a;
		COLOR = vec4(outline_color.rgb, clamp(alpha, 0f, 1f));
	}
	
}