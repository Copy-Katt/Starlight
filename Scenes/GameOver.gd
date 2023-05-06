extends Control

func _on_animation_finished(_anim_name):
	Global.switch_scene("res://Scenes/Menus/TitleScreen.tscn")
