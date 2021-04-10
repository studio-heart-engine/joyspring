shader_type canvas_item;

uniform vec4 color : hint_color;

void fragment() {
	if(texture(TEXTURE, UV).a > 0.0) {
		COLOR = color;
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}