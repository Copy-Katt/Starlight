@tool
extends Control

@export var category := 'none'

@export var option_name := 'CheckBox':
	set(value):
		$CheckBox.text = value
		option_name = value
@export var option_id := 'checkbox'
@export var option_value := false:
	set(value):
		$CheckBox.button_pressed = value
		option_value = value

func _ready():
	$CheckBox.button_pressed = option_value

func _on_check_box_pressed():
	Global.Sound.play_sound('MenuGrab', SoundIgnoreType.PASS_THROUGH)
	option_value = $CheckBox.button_pressed
	Options.save_option(category, option_id, $CheckBox.button_pressed)
	if Options.def_options[category].settings[option_id].has('updates') and Options.def_options[category].settings[option_id].updates:
			Options.reload_option(category, option_id)
	else:
		Options.reload_option(category, option_id)
