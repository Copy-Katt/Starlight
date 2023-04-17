shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D palettes : filter_nearest;
uniform int cur_palette = 0;

void fragment() {
	vec4 coolor = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = texture(palettes, vec2(coolor.r, float(cur_palette)/4.0));
}
