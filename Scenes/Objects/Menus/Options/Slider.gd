@tool
extends Control

@export var option_name := 'Slider'
@export var option_id := 'slider'
@export var option_value := 0:
	set(value):
		$HScrollBar.value = clamp(value, option_min, option_max)
		option_value = clamp(value, option_min, option_max)

@export var option_min := 0
@export var option_max := 100
@export var option_step := 1

@export var option_swaps := {}
@export var option_suffix := ''

func _ready():
	$HScrollBar.value = option_value

func _process(_delta):
	var display_option_value = str(option_value) + option_suffix
	if option_swaps.keys().has(str(option_value)):
		display_option_value = option_swaps[str(option_value)]
	$Label.text = '            '+option_name
	$HScrollBar.position.x = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size")).x+10
	$Value.text = str(display_option_value)
	
	$HScrollBar.min_value = option_min
	$HScrollBar.max_value = option_max
	$HScrollBar.step = option_step
	
	option_value = $HScrollBar.value
