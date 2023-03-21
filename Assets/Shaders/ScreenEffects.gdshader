shader_type canvas_item;

uniform float transition_value = 0.0;
uniform vec4 transition_color : source_color;

uniform float shake_intensity = 1.0;
uniform bool shake_active = false;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_enable;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	bool is_transition_pixel = false;
	if (!(distance(1.0+sin((UV.x+UV.y)*20.0)/100.0, UV.x) >= transition_value) &&
		!(distance(1.0+sin((UV.x+UV.y)*20.0)/100.0, UV.x) <= transition_value-1.5)) {
		is_transition_pixel = true;
	}
	if (is_transition_pixel) {
		COLOR = transition_color;
	} else if (shake_active) {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(
			0.5-rand( vec2(TIME) ),
			0.5-rand( vec2(rand(vec2(TIME))) )
		)/500.0 * shake_intensity);
	} else {
		discard;
	}
}
