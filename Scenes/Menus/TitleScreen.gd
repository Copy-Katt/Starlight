extends Node2D

var cur_selected = 0
var last_cur_selected = -1
var functions = [
	func (): 
		Global.switch_scene("res://Scenes/Game.tscn")
		Global.play_music('EndlessVoid',false),
	func (): Global.switch_scene("res://Scenes/Menus/OptionsMenu.tscn"),
	func (): Global.switch_scene("res://Scenes/Closing.tscn")
]

var mouse_controlled = false
var _mouse_pos = Vector2.ZERO
var mouse_pos = Vector2.ZERO

func _ready():
	randomize()
	update_selection()
	
func _process(_delta):
	last_cur_selected = cur_selected
	
	_mouse_pos = mouse_pos
	mouse_pos = get_global_mouse_position()
	if mouse_pos != _mouse_pos:
		mouse_controlled = true
	
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up"):
		mouse_controlled = false
		cur_selected = abs(wrap(cur_selected-1, 0, $ChooseOptions.get_child_count()))
		update_selection()
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_down"):
		mouse_controlled = false
		cur_selected = abs(wrap(cur_selected+1, 0, $ChooseOptions.get_child_count()))
		update_selection()
	if Input.is_action_just_pressed("ui_accept"):
		if cur_selected >= 0:
			if Global.can_swap_scene:
				Global.Sound.play_sound('MenuAccept', SoundIgnoreType.PASS_THROUGH)
			functions[cur_selected].call()
	
	if mouse_controlled:
		cur_selected = -1
	for i in $ChooseOptions.get_children():
		if mouse_controlled and i.is_hovered():
			cur_selected = i.get_index()
			if cur_selected != last_cur_selected:
				update_selection()
	
	if last_cur_selected != cur_selected and cur_selected >= 0:
		Global.Sound.play_sound('MenuSwap', SoundIgnoreType.REPLACE)

func update_selection():
	var selected_node = $ChooseOptions.get_child(cur_selected)
	for i in $ChooseOptions.get_children():
		if i == selected_node:
			i.add_theme_color_override('font_color', Color('f5ffe8'))
			i.add_theme_color_override('font_pressed_color', Color('f5ffe8'))
			i.add_theme_color_override('font_hover_color', Color('f5ffe8'))
			i.add_theme_color_override('icon_normal_color', Color('f5ffe8'))
			i.add_theme_color_override('icon_pressed_color', Color('f5ffe8'))
			i.add_theme_color_override('icon_hover_color', Color('f5ffe8'))
			if i == $ChooseOptions/Play:
				$ChooseOptions/Play.icon.region.position.y = 24
		else:
			i.add_theme_color_override('font_color', Color('ff5277'))
			i.add_theme_color_override('font_pressed_color', Color('ff5277'))
			i.add_theme_color_override('font_hover_color', Color('ff5277'))
			i.add_theme_color_override('icon_normal_color', Color('ff5277'))
			i.add_theme_color_override('icon_pressed_color', Color('ff5277'))
			i.add_theme_color_override('icon_hover_color', Color('ff5277'))
			if i == $ChooseOptions/Play:
				$ChooseOptions/Play.icon.region.position.y = 0
	
	$ChooseOptions/Play.add_theme_color_override('icon_normal_color', Color('ffffff'))
	$ChooseOptions/Play.add_theme_color_override('icon_pressed_color', Color('ffffff'))
	$ChooseOptions/Play.add_theme_color_override('icon_hover_color', Color('ffffff'))
