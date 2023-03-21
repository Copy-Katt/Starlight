@tool
extends Control

@export var category := 'none'

@export var option_name := 'Slider'
@export var option_id := 'slider'
@export var option_value := 0:
	set(value):
		$HScrollBar.value = clamp(value, option_min, option_max)
		option_value = clamp(value, option_min, option_max)

@export var option_min := 0:
	set(value):
		$HScrollBar.min_value = value
		option_min = value
@export var option_max := 100:
	set(value):
		$HScrollBar.max_value = value
		option_max = value
@export var option_step := 1:
	set(value):
		$HScrollBar.step = value
		option_step = value

@export var option_swaps := {}
@export var option_suffix := ''

func _process(_delta):
	var display_option_value = str(option_value) + option_suffix
	if option_swaps.keys().has(str(option_value)):
		display_option_value = option_swaps[str(option_value)]
	$Label.text = option_name
	$HScrollBar.position.x = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size")).x+34
	$Value.text = str(display_option_value)
	
func _on_value_changed(value):
	Global.Sound.play_sound('MenuGrab', SoundIgnoreType.PASS_THROUGH)
	option_value = value
	Options.save_option(category, option_id, value)
	if Options.def_options[category].settings[option_id].has('updates'):
		if Options.def_options[category].settings[option_id].updates:
			Options.reload_option(category, option_id)
	else:
		Options.reload_option(category, option_id)
