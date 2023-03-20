extends Node2D

var option_types := {
	'bool': preload("res://Scenes/Objects/Menus/Options/Checkbox.tscn"),
	'num': preload("res://Scenes/Objects/Menus/Options/Slider.tscn")
}

var cur_category := 'video'

func _ready():
	for i in Options.options[cur_category].settings.keys():
		var i_val = Options.options[cur_category].settings[i]
		
		var option = option_types[i_val.type].instantiate()
		option.option_id = i
		option.option_name = i_val.name
		
		# Change for geting settings
		if i_val.has('def_value'): option.option_value = i_val.def_value
		
		match(i_val.type):
			'num':
				if i_val.has('min'): option.option_min = i_val.min
				if i_val.has('max'): option.option_max = i_val.max
				if i_val.has('step'): option.option_step = i_val.step
				if i_val.has('swaps'): option.option_swaps = i_val.swaps
				if i_val.has('suffix'): option.option_suffix = i_val.suffix
		
		$Options/VBoxContainer.add_child(option)
