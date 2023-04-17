shader_type canvas_item;

uniform float strengthX = 0.0125;
uniform float strengthY = 0.0625;

void vertex() {
	UV.x += TIME*strengthX;
	UV.y += sin(TIME/5.0)*strengthY;
}
