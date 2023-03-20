shader_type canvas_item;

uniform float multiplier = 10.0;

void vertex() {
	float val = TIME*multiplier;
	VERTEX *= mat2(vec2(sin(val), cos(val)), vec2(-cos(val), sin(val)));
}

