shader_type canvas_item;

uniform bool invert = false;

void vertex() {
	float val = TIME*2.0;
	if (invert) {
		val *= -1.0;
		val += 0.7854;
	}
	VERTEX *= mat2(
		vec2(sin(val), cos(val)),
		vec2(-cos(val), sin(val))
	);
}
