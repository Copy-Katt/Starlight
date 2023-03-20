extends CanvasLayer

@onready var Sound := $SCSoundManager
var Game : Node

var gem_amount := 0
var lifes := 3
var score := 0

var start_pos : Vector2
var cur_music = null

# Level Information
var level_data : Node2D

func _ready():	
	randomize()
	play_music('EndlessVoid')
	
func _process(_delta):
	if Engine.max_fps != 0:
		$Info.text = str(min(Engine.get_frames_per_second(), Engine.max_fps)) + ' / ' + str(Engine.max_fps) + ' FPS'
	else:
		$Info.text = str(Engine.get_frames_per_second()) + ' FPS'
	
	lifes = max(0,lifes)
	score = max(0,score)
	gem_amount = max(0,gem_amount)

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
	var transition_time = 0.64
	var tween = get_tree().create_tween()
	tween.tween_property($Transition.get_material(), "shader_parameter/value", 2.5, transition_time)
	await get_tree().create_timer(transition_time/2+0.05).timeout
	get_tree().change_scene_to_file(file_path)
	await get_tree().create_timer(transition_time/2+0.05).timeout
	$Transition.get_material().set_shader_parameter('value', 0.0)
	
func reset_scene():
	var transition_time = 0.64
	var tween = get_tree().create_tween()
	tween.tween_property($Transition.get_material(), "shader_parameter/value", 2.5, transition_time)
	await get_tree().create_timer(transition_time/2+0.05).timeout
	get_tree().reload_current_scene()
	await get_tree().create_timer(transition_time/2+0.05).timeout
	$Transition.get_material().set_shader_parameter('value', 0.0)
	
func load_level(level_name):
	level_data = load("res://Assets/Data/Levels/"+level_name+".tscn").instantiate()
	Game.load_level(level_name)
#	ResourceSaver.save(level_data, 'user://test.tres')
	
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
