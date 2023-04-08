shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D palettes : filter_nearest;
uniform int cur_palette = 0;

void fragment() {
	vec4 coolor = texture(SCREEN_TEXTURE,SCREEN_UV);
	float palletes_pixel_height = 1.0/float(textureSize(palettes, 0).y);
	if (coolor == vec4(1,1,1,1)) {
		coolor = texture(palettes,vec2(0.0,float(cur_palette)*palletes_pixel_height) + 1.0/8.0);
	}
	if (coolor == vec4(1,0,0,1)) {
		coolor = texture(palettes,vec2(1.0/4.0,float(cur_palette)*palletes_pixel_height) + 1.0/8.0);
	}
	if (coolor == vec4(0,1,0,1)) {
		coolor = texture(palettes,vec2(2.0/4.0,float(cur_palette)*palletes_pixel_height) + 1.0/8.0);
	}
	if (coolor == vec4(0,0,1,1)) {
		coolor = texture(palettes,vec2(3.0/4.0,float(cur_palette)*palletes_pixel_height) + 1.0/8.0);
	}
	COLOR = coolor;
}
