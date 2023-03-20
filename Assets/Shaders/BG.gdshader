shader_type canvas_item;

uniform float strengthX = 0.125;
uniform float strengthY = 0.625;

void vertex() {
	UV.x += TIME*strengthX/10.0;
	UV.y += sin(TIME/5.0)*strengthY/10.0;
}
