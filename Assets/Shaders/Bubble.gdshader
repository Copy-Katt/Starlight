shader_type canvas_item;

void vertex() {
	float val = 2.0+TIME*2.0+VERTEX.x;
	VERTEX.x += sin(1.0+val)*0.5;
	VERTEX.y += sin(val)*0.5;
}