extends CanvasLayer

@onready var Sound := $SCSoundManager
var Game : Node

var can_swap_scene := true

var gem_amount := 0:
	set(value):
		gem_amount = max(0,value)
var lifes := 3:
	set(value):
		lifes = max(0,value)
var score := 0:
	set(value):
		score = max(0,value)

var start_pos : Vector2
var cur_music = null

# Level Information
var level_data : Node2D

var music_vol := 100
var sfx_vol := 100
var screenshake_factor := 1

var keycode_name_map := {
	'CapsLock': 'CpsLk',
	'Backspace': 'BckSp',
	'Escape': 'Esc',
	'QuoteLeft': '"',
	'BracketLeft': '[',
	'BracketRight': ']',
	'Apostrophe': '\'',
	'Slash': '/',
	'BackSlash': '\\',
	'Bar': '|',
	'Windows': 'Wnds',
	'Comma': ',',
	'Period': '.',
	'Insert': 'Ins',
	'PageUp': 'PgUp',
	'PageDown': 'PgDn',
	'Delete': 'Del',
	'ScrollLock': 'ScrLk'
}

var joypad_name_map := {
	"InputEventJoypadButton": {
		JoyButton.JOY_BUTTON_INVALID: "Invalid",
		JoyButton.JOY_BUTTON_A: "↓ Button",
		JoyButton.JOY_BUTTON_B: "→ Button",
		JoyButton.JOY_BUTTON_X: "← Button",
		JoyButton.JOY_BUTTON_Y: "↑ Button",
		JoyButton.JOY_BUTTON_BACK: "Select",
		JoyButton.JOY_BUTTON_GUIDE: "Home",
		JoyButton.JOY_BUTTON_START: "Start",
		JoyButton.JOY_BUTTON_LEFT_STICK: "Left Stick",
		JoyButton.JOY_BUTTON_RIGHT_STICK: "Right Stick",
		JoyButton.JOY_BUTTON_LEFT_SHOULDER: "L1",
		JoyButton.JOY_BUTTON_RIGHT_SHOULDER: "R1",
		JoyButton.JOY_BUTTON_DPAD_UP: "D-pad ↑",
		JoyButton.JOY_BUTTON_DPAD_DOWN: "D-pad ↓",
		JoyButton.JOY_BUTTON_DPAD_LEFT: "D-pad ←",
		JoyButton.JOY_BUTTON_DPAD_RIGHT: "D-pad →",
	},
	"InputEventJoypadMotion": {
		JoyAxis.JOY_AXIS_INVALID: ["Invalid", "Invalid"],
		JoyAxis.JOY_AXIS_LEFT_X: ["LS-Left", "LS-Right"],
		JoyAxis.JOY_AXIS_LEFT_Y: ["LS-Up", "LS-Down"],
		JoyAxis.JOY_AXIS_RIGHT_X: ["RS-Left", "RS-Right"],
		JoyAxis.JOY_AXIS_RIGHT_Y: ["RS-Up", "RS-Down"],
		JoyAxis.JOY_AXIS_TRIGGER_LEFT: ["L2", "L2"],
		JoyAxis.JOY_AXIS_TRIGGER_RIGHT: ["R2", "R2"]
	}
}

var cursor = preload("res://Assets/Images/Menus/General/Mouse.png")

func _ready():
	randomize()
	play_music('EndlessVoid')
	DisplayServer.window_set_title("♦ Starlight ♦")
	for i in 3:
		var _tex = AtlasTexture.new()
		_tex.atlas = cursor.get_image()
		_tex.region = Rect2(0, i*6, 9, 6)
		
		var tex = ImageTexture.create_from_image(_tex.get_image())
		Input.set_custom_mouse_cursor(tex, i as Input.CursorShape, Vector2(4,1))
	await get_tree().process_frame
	DisplayServer.window_set_position((DisplayServer.screen_get_size()-DisplayServer.window_get_size())/2)
	
func _process(_delta):
	if Engine.max_fps != 0:
		$Info.text = str(min(Engine.get_frames_per_second(), Engine.max_fps)) + '/' + str(Engine.max_fps) + ' FPS'
	else:
		$Info.text = str(Engine.get_frames_per_second()) + ' FPS'

func fill_num(num: int, length: int) -> String:
	var string = str(num)
	while string.length() < length:
		string = '0'+string
	return string
	
func rotate_around_point(vec: Vector2, center: Vector2, angle:float) -> Vector2:
	var diff:Vector2 = vec - center
	diff = diff.rotated(angle)
	diff += center
	return diff

func play_music(file_name: String):
	if file_name != cur_music:
		var stream = load("res://Assets/Music/"+file_name+".wav")
		$Music.stream = stream
		$Music.play()
	
func switch_scene(file_path : String):
	if can_swap_scene:
		can_swap_scene = false
		var transition_time = 0.64
		var tween = get_tree().create_tween()
		tween.tween_property($ScreenEffects.get_material(), "shader_parameter/transition_value", 2.5, transition_time)
		await get_tree().create_timer(transition_time/2+0.05).timeout
		get_tree().change_scene_to_file(file_path)
		await get_tree().create_timer(transition_time/2+0.05).timeout
		$ScreenEffects.get_material().set_shader_parameter('transition_value', 0.0)
		for i in 5:
			await get_tree().process_frame
		can_swap_scene = true
	
func reset_scene():
	if can_swap_scene:
		can_swap_scene = false
		var transition_time = 0.64
		var tween = get_tree().create_tween()
		tween.tween_property($ScreenEffects.get_material(), "shader_parameter/transition_value", 2.5, transition_time)
		await get_tree().create_timer(transition_time/2+0.05).timeout
		get_tree().reload_current_scene()
		await get_tree().create_timer(transition_time/2+0.05).timeout
		$ScreenEffects.get_material().set_shader_parameter('transition_value', 0.0)
		for i in 5:
			await get_tree().process_frame
		can_swap_scene = true
	
func load_level(level_name):
	level_data = load("res://Assets/Data/Levels/"+level_name+".tscn").instantiate()
	Game.load_level(level_name)

func screen_shake(duration, intensity):
	$ScreenEffects.material.set_shader_parameter('shake_intensity', intensity*screenshake_factor)
	$ScreenEffects.material.set_shader_parameter('shake_active', true)
	await get_tree().create_timer(duration).timeout
	$ScreenEffects.material.set_shader_parameter('shake_active', false)
	
func string_from_keycode(keycode):
	if OS.get_keycode_string(keycode) in keycode_name_map.keys():
		return keycode_name_map[OS.get_keycode_string(keycode)]
	else:
		return OS.get_keycode_string(keycode)


#func send_to_discord(webhook, info):
#	var http_request = HTTPRequest.new()
#	add_child(http_request)
#	var body = JSON.stringify(info)
#	http_request.request(
#		webhook,
#		["Content-Type:application/json"],
#		true,
#		HTTPClient.METHOD_POST,
#		body
#	)
