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
				if !options[cat].has(setting):
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
			reload_option(cat, id)
	
func reload_option(_cat, id):
	var value = options[_cat][id]
	match id:
		'max_fps':
			Engine.max_fps = int(fmod(value, 250))
		'window_scale':
			DisplayServer.window_set_size(Vector2i(416, 240)*value)
			DisplayServer.window_set_position((DisplayServer.screen_get_size()-DisplayServer.window_get_size())/2)
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
			
			
		'music_vol':
			Global.get_node('Music').volume_db = (value/2-50)
		'sfx_vol':
			Global.Sound.vol = (value/2-50)
			
		'screenshake_factor':
			Global.screenshake_factor = value/100
