shader_type canvas_item;

uniform bool invert_direction = false;

void vertex() {
	float val = TIME*2.0;
	mat2 mat;
	if (invert_direction) {
		mat = mat2(
			vec2(sin(val+PI/4.0), cos(val+PI/4.0)),
			vec2(cos(val+PI/4.0), -sin(val+PI/4.0))
		);
	} else {
		mat = mat2(
			vec2(sin(val), cos(val)),
			vec2(-cos(val), sin(val))
		);
	}
	VERTEX *= mat;
}
