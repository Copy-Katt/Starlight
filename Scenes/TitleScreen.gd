extends Node2D

var cur_selected = 0
var last_cur_selected = 0
var functions = [
	func (): Global.switch_scene("res://Scenes/Game.tscn"),
	func (): Global.switch_scene("res://Scenes/OptionsMenu.tscn"),
	func (): Global.switch_scene("res://Scenes/Closing.tscn")
]

var mouse_controlled = false
var _mouse_pos = Vector2.ZERO
var mouse_pos = Vector2.ZERO

func _ready():
	randomize()
	update_selection()
	for i in $CornerSprites.get_children():
		i.position.x = sin(i.get_index()/float($CornerSprites.get_child_count())*PI*2)*randi_range(96, 128)
		i.position.y = cos(i.get_index()/float($CornerSprites.get_child_count())*PI*2)*randi_range(96, 128)
	
func _process(_delta):
	last_cur_selected = cur_selected
	
	_mouse_pos = mouse_pos
	mouse_pos = get_global_mouse_position()
	if mouse_pos != _mouse_pos:
		mouse_controlled = true
	
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up"):
		mouse_controlled = false
		cur_selected -= 1
		update_selection()
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_down"):
		mouse_controlled = false
		cur_selected += 1
		update_selection()
	if Input.is_action_just_pressed("ui_accept"):
		Global.Sound.play_sound('MenuAccept', SoundIgnoreType.PASS_THROUGH)
		functions[cur_selected%$ChooseOptions.get_child_count()].call()
	
	for i in $ChooseOptions.get_children():
		if mouse_controlled and i.is_hovered():
			cur_selected = i.get_index()
			update_selection()
	
	if last_cur_selected != cur_selected:
		Global.Sound.play_sound('MenuSwap', SoundIgnoreType.REPLACE)
	
	
	for i in $CornerSprites.get_children():
		i.global_rotation = 0
	$CornerSprites.rotation += _delta*0.1

func update_selection():
	var selected_node = $ChooseOptions.get_child(cur_selected%$ChooseOptions.get_child_count())
	for i in $ChooseOptions.get_children():
		if i == selected_node:
			i.add_theme_color_override('font_color', Color('f5ffe8'))
		else:
			i.add_theme_color_override('font_color', Color('686f99'))
