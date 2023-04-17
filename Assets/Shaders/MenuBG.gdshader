shader_type canvas_item;

uniform float strengthX = -0.05;
uniform float strengthY = -0.025;

void vertex() {
	UV.x += TIME*strengthX;
	UV.y += TIME*strengthY;
}
