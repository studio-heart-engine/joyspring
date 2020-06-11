shader_type canvas_item;
render_mode unshaded;
 
uniform float width : hint_range(0.0, 16.0);
uniform vec4 outline_color : hint_color;
 
void fragment()
{
    vec2 size = vec2(width) / vec2(textureSize(TEXTURE, 0));
   
    vec4 sprite_color = texture(TEXTURE, UV);
   
    float alpha = sprite_color.a;
    alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	
    COLOR = vec4(outline_color.rgb, clamp(alpha, 0.0, 1.0));
}
