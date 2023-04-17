shader_type canvas_item;

uniform bool invert_direction = false;

void vertex() {
	float val = TIME*2.0;
	if (invert_direction) {
		val *= -1.0;
		val -= PI/4.0;
	}
	VERTEX *= mat2(
		vec2(sin(val), cos(val)),
		vec2(-cos(val), sin(val))
	);
}
