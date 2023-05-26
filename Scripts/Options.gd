extends Node

var def_options = JSON.parse_string(
	FileAccess.open(
		"res://Assets/Data/Options.json", 
		FileAccess.READ
	).get_as_text()
)


var options := {}

func _ready():
	if FileAccess.file_exists("user://saved_options.json"):
		options = JSON.parse_string(FileAccess.open("user://saved_options.json", FileAccess.READ).get_as_text())
		for cat in def_options.keys():
			if !options.has(cat):
				options[cat] = {}
			for setting in def_options[cat].settings.keys():
				if !options[cat].has(setting) and def_options[cat].settings[setting].has("def_value"):
					options[cat][setting] = def_options[cat].settings[setting].def_value
		save()
				
	else:
		for cat in def_options.keys():
			for opt in def_options[cat].settings.keys():
				var val = def_options[cat].settings[opt]
				if !options.has(cat):
					options[cat] = {}
				options[cat][opt] = val.def_value
		save()
	reload()

func save():
	FileAccess.open(
		"user://saved_options.json", FileAccess.WRITE
	).store_string(JSON.stringify(options))

func save_option(_cat, _id, _value):
	options[_cat][_id] = _value
	
func reload():
	for cat in options.keys():
		for id in options[cat].keys():
			if !id.begins_with('_'):
				reload_option(cat, id)
	
func reload_option(_cat, id):
	var value = options[_cat][id]
	
	if def_options.has(_cat) and def_options[_cat].settings.has(id) and def_options[_cat].settings[id].has('type'):
		if def_options[_cat].settings[id].type == 'key':
			InputMap.action_erase_events(id)
			for i in value:
				var ie = InputEventKey.new()
				ie.keycode = i
				InputMap.action_add_event(id, ie)
	match id:
		'max_fps':
			Engine.max_fps = int(fmod(value, 250))
		'window_scale':
			DisplayServer.window_set_size(Vector2i(416, 240)*value)
		'vsync':
			DisplayServer.window_set_vsync_mode(value)
		'borderless':
			var old_size = DisplayServer.window_get_size()
			get_viewport().borderless = value
			DisplayServer.window_set_size(old_size)
		'fullscreen':
			get_viewport().mode = 3 if value else 0
		'show_fps':
			Global.get_node('Info').visible = value
		'pixel_perfect':
			get_viewport().content_scale_mode = 1+int(value)
			
			
		'music_vol':
			Global.get_node('Music').volume_db = linear_to_db(value/100)
		'sfx_vol':
			Global.Sound.vol = linear_to_db(value/100)
			
			
		'screenshake_factor':
			Global.screenshake_factor = value/100
			
			
		'tablet_color_scheme':
			if get_tree().get_root().has_node("OptionsMenu"):
				get_tree().get_root().get_node("OptionsMenu").reload_tablet()
			
