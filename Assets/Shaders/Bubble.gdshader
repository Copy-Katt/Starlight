shader_type canvas_item;

void vertex() {
	VERTEX.x += sin(3.0+TIME*2.0+VERTEX.y)*0.5;
	VERTEX.y += sin(2.0+TIME*2.0+VERTEX.x)*0.5;
}