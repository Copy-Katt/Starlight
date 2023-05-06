extends CanvasLayer

@export var spikr_alt_mat : ShaderMaterial

@onready var Sound := $SCSoundManager
var Game : Node

var can_swap_scene := true

var gem_amount := 0:
	set(value):
		gem_amount = max(0,value)
var lifes := 3:
	set(value):
		lifes = max(-1,value)
var score := 0:
	set(value):
		score = max(0,value)

var start_pos : Vector2
var cur_music = null

var music_vol := 100
var sfx_vol := 100
var screenshake_factor := 1

var _close = 0

func _ready():
	notification(NOTIFICATION_WM_CLOSE_REQUEST)
	randomize()
	play_music('Menu')
	DisplayServer.window_set_title("♦ Starlight ♦")
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

func play_music(file_name: String, fade = false):
	if file_name != cur_music:
		var stream = load("res://Assets/Music/"+file_name+".wav")
		if !fade:
			$Music.stream = stream
			$Music.play()
		else:
			var db = $Music.volume_db
			var transition_time = 0.64
			
			var tween = get_tree().create_tween()
			tween.tween_property($Music, "volume_db", -80.0, transition_time/2.0)
			await tween.finished
			
			$Music.stream = stream
			$Music.play()
			
			tween = get_tree().create_tween()
			tween.tween_property($Music, "volume_db", db, transition_time/2.0)
			
	
func switch_scene(file_path : String, force = false, instant = false):
	if (can_swap_scene or force) and !instant:
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
	elif (can_swap_scene or force) and instant:
		get_tree().change_scene_to_file(file_path)
	
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

func screen_shake(duration, intensity):
	$ScreenEffects.material.set_shader_parameter('shake_intensity', intensity*screenshake_factor)
	$ScreenEffects.material.set_shader_parameter('shake_active', true)
	await get_tree().create_timer(duration).timeout
	$ScreenEffects.material.set_shader_parameter('shake_active', false)
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if _close >= 1 and get_tree().current_scene.name != 'Closing':
			switch_scene("res://Scenes/Closing.tscn", true, true)
		_close += 1
