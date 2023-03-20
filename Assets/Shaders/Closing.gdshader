shader_type canvas_item;

uniform float value = 0;

void fragment() {
	//COLOR.a = 1.0-value;
	if (distance(vec2(0.5), vec2(UV.x)) > 1.0-value) {
		discard;
	}
}
