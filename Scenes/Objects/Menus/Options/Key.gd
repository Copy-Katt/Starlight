extends Control

@export var category := 'none'

@export var option_name := 'Key':
	set(value):
		$Label.text = value
		option_name = value
		
@export var option_id := 'key'

@export var option_value := [KEY_A,KEY_LEFT]:
	set(value):
		$Key1.text = Global.string_from_keycode(value[0])
		$Key2.text = Global.string_from_keycode(value[1])
		option_value = value

var selecting_bind := 0
	
func _input(event):
	if event is InputEventKey and selecting_bind != 0:
		var key_str:String = Global.string_from_keycode(event.keycode)
		print(str(selecting_bind) + key_str)
		var val = option_value
		val[selecting_bind-1] = event.keycode
		option_value = val
		selecting_bind = 0

func _on_key_pressed(id):
	selecting_bind = id
