shader_type canvas_item;

uniform sampler2D palettes : filter_nearest;
uniform float palette_offset = 0.0;

void fragment() {
	vec4 pixel = texture(TEXTURE,UV);
	if (pixel.a == 0.0) {
		discard;
	}
	COLOR = texture(palettes, vec2(
		(pixel.r+pixel.g+pixel.b)/3.0,
		palette_offset
	));
}
