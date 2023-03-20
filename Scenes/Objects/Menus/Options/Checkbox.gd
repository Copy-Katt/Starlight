@tool
extends Control

@export var option_name := 'CheckBox'
@export var option_id := 'checkbox'
@export var option_value := false:
	set(value):
		$CheckBox.button_pressed = value
		option_value = value

func _ready():
	$CheckBox.button_pressed = option_value

func _process(_delta):
	$CheckBox.text = option_name

	option_value = $CheckBox.button_pressed
