//shader_type canvas_item;
//
//uniform vec4 color : hint_color;
//
//void fragment() {
//	if(texture(TEXTURE, UV).a > 0.0) {
//		COLOR = color;
//	} else {
//		COLOR = texture(TEXTURE, UV);
//	}
//}
shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float mixture;

void fragment() 
{
    COLOR = texture(TEXTURE, UV);
    COLOR.rgb = mix(COLOR.rgb, color.rgb, mixture);
}