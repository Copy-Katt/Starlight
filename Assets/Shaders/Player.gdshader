shader_type canvas_item;

uniform vec4 visor_color : source_color;
uniform vec4 visor_color_2 : source_color;

uniform vec3 shine_color : source_color;

uniform vec3 flash_color : source_color;
uniform bool flashing = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (!flashing) {
		if (mod((UV.x+UV.y)/2.0-TIME, 3.0) > 2.95 && 
		(abs(COLOR.r - visor_color.r) <= 0.05 || abs(COLOR.r - visor_color_2.r) <= 0.05) && 
		(abs(COLOR.g - visor_color.g) <= 0.05 || abs(COLOR.g - visor_color_2.g) <= 0.05) && 
		(abs(COLOR.b - visor_color.b) <= 0.05 || abs(COLOR.b - visor_color_2.b) <= 0.05)) {
			COLOR.rgb = shine_color;
		}
	} else {
		COLOR.rgb = flash_color;
	}
}
