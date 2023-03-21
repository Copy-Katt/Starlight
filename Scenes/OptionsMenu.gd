extends Control

var option_types := {
	'bool': preload("res://Scenes/Objects/Menus/Options/Checkbox.tscn"),
	'num': preload("res://Scenes/Objects/Menus/Options/Slider.tscn")
}

var categories := [
	'video',
	'audio',
	'input',
	'accessibility'
]

var cur_category := 0

func _ready():
	load_page()
	
func load_page():
	for i in Options.def_options[categories[cur_category]].settings.keys():
		var i_val = Options.def_options[categories[cur_category]].settings[i]
		
		var option = option_types[i_val.type].instantiate()
		option.option_id = i
		option.option_name = i_val.name
		option.category = categories[cur_category]
		
		match(i_val.type):
			'num':
				if i_val.has('min'): option.option_min = i_val.min
				if i_val.has('max'): option.option_max = i_val.max
				if i_val.has('step'): option.option_step = i_val.step
				if i_val.has('swaps'): option.option_swaps = i_val.swaps
				if i_val.has('suffix'): option.option_suffix = i_val.suffix
		
		if Options.options[categories[cur_category]].keys().has(i):
			option.option_value = Options.options[categories[cur_category]][i]
		$Options/VBoxContainer.add_child(option)
			
		
	$Title.text = Options.def_options[categories[cur_category]].name
	$Title/TitleIcon.texture = $Categories.get_child(cur_category).texture_normal


func _on_category_pressed(cat):
	cur_category = cat
	for i in $Options/VBoxContainer.get_children():
		i.queue_free()
	load_page()
	Global.Sound.play_sound('MenuSwap', SoundIgnoreType.PASS_THROUGH)

func _on_back_pressed():
	Options.save()
	Options.reload()
	if Global.can_swap_scene:
		Global.Sound.play_sound('MenuAccept', SoundIgnoreType.PASS_THROUGH)
	Global.switch_scene("res://Scenes/TitleScreen.tscn")
