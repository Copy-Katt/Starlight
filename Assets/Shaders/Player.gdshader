shader_type canvas_item;

uniform sampler2D shine_bitmask : filter_nearest;

uniform vec3 flash_color : source_color;
uniform bool flashing = false;

void fragment() {
	vec4 shine_color = texture(shine_bitmask, UV);
	if (!flashing) {
		if (mod((UV.x+UV.y)/2.0-TIME, 3.0) > 2.95 && 
		shine_color.a > 0.0) {
			COLOR.rgb = shine_color.rgb;
		} else {
			COLOR = texture(TEXTURE, UV);
		}
	} else {
		COLOR.rgb = flash_color;
	}
}
