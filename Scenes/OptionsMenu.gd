extends Control

var option_types := {
	'bool': preload("res://Scenes/Objects/Menus/Options/Checkbox.tscn"),
	'num': preload("res://Scenes/Objects/Menus/Options/Slider.tscn"),
	'key': preload("res://Scenes/Objects/Menus/Options/Key.tscn")
}

var cur_category := 0

func _ready():
	reload_tablet()
	load_page()
	
func anim_load_page(cat):
	var dir = (cur_category-cat)/abs(cur_category-cat)
	cur_category = cat
	var transition_time = 0.1
	var def_pos = $Screen/Options/VBoxContainer.position.x
	
	load_page()
	var tween = get_tree().create_tween()
	tween.tween_property(
		$Screen/Options/VBoxContainer, 
		"position:x",
		def_pos+dir*-3,
		transition_time/2
	)
	await get_tree().create_timer(transition_time/2+0.05).timeout
	tween = get_tree().create_tween()
	tween.tween_property(
		$Screen/Options/VBoxContainer, 
		"position:x",
		def_pos,
		transition_time/2
	)
	
func load_page():
	for i in Options.def_options[Options.def_options.keys()[cur_category]].settings.keys():
		var i_val = Options.def_options[Options.def_options.keys()[cur_category]].settings[i]
		
		var option = option_types[i_val.type].instantiate()
		option.option_id = i
		option.option_name = i_val.name
		option.category = Options.def_options.keys()[cur_category]
		
		match(i_val.type):
			'num':
				if i_val.has('min'): option.option_min = i_val.min
				if i_val.has('max'): option.option_max = i_val.max
				if i_val.has('step'): option.option_step = i_val.step
				if i_val.has('swaps'): option.option_swaps = i_val.swaps
				if i_val.has('suffix'): option.option_suffix = i_val.suffix
		
		if Options.options[Options.def_options.keys()[cur_category]].keys().has(i):
			option.option_value = Options.options[Options.def_options.keys()[cur_category]][i]
		$Screen/Options/VBoxContainer.add_child(option)
	
	$Screen/Title.text = Options.def_options[Options.def_options.keys()[cur_category]].name
	$Screen/Title/TitleIcon.texture = $Screen/Categories.get_child(cur_category).texture_normal


func _on_category_pressed(cat):
	if cur_category-cat != 0:
		for i in $Screen/Options/VBoxContainer.get_children():
			i.queue_free()
		anim_load_page(cat)
		Global.Sound.play_sound('MenuSwap', SoundIgnoreType.PASS_THROUGH)

func _on_back_pressed():
	Options.save()
	Options.reload()
	if Global.can_swap_scene:
		Global.Sound.play_sound('MenuAccept', SoundIgnoreType.PASS_THROUGH)
	Global.switch_scene("res://Scenes/TitleScreen.tscn")

func _on_reload_pressed():
	Global.Sound.play_sound('MenuAccept', SoundIgnoreType.PASS_THROUGH)
	Options.reload()
	
func reload_tablet():
	$Screen/ColorFilter.material.set_shader_parameter('palette_offset', Options.options.customization.tablet_color_scheme/4.0)
