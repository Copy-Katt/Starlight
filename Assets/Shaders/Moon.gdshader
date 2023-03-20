shader_type canvas_item;

void vertex() {
	float val = sin(TIME*2.0)/4.0+PI/2.0;
	VERTEX *= mat2(vec2(sin(val), cos(val)), vec2(-cos(val), sin(val)));
}