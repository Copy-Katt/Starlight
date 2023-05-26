shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D palettes : filter_nearest;
uniform float palette_offset = 0.0;

void fragment() {
	vec4 pixel = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = texture(palettes, vec2(
		(pixel.r+pixel.g+pixel.b)/3.0,
		palette_offset
	));
}
