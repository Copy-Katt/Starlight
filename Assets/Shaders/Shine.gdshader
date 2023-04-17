shader_type canvas_item;

uniform vec3 shine_color : source_color;

void fragment() {
	if (mod((UV.x+UV.y)/2.0-TIME, 3.0) > 2.9) {
		COLOR.rgb = shine_color;
	}
}
