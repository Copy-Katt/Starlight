shader_type canvas_item;

uniform float value = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	if (distance(1.0+sin((UV.x+UV.y)*20.0)/100.0, UV.x) >= value ||
		distance(1.0+sin((UV.x+UV.y)*20.0)/100.0, UV.x) <= value-1.5) {
		discard;
	}
	//COLOR.a = (sin((value-0.5)*PI)+1.0)*0.5;
}
