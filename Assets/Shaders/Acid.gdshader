shader_type canvas_item;


void fragment() {
	COLOR = texture(TEXTURE,UV+vec2(TIME*2.0,0));
}
void vertex() {
	VERTEX.y += sin(TIME)*2.0;
}
