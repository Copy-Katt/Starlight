shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D palettes : filter_nearest;
uniform float palette_offset = 0.0;

void fragment() {
	COLOR = texture(palettes, vec2(
		texture(SCREEN_TEXTURE,SCREEN_UV).r, 
		palette_offset
	));
}
