class_name SCSoundManager
extends Node

var sound_data = {
	'Coin': [
		preload("res://Assets/SFX/Coin0.wav"),
		preload("res://Assets/SFX/Coin1.wav"),
		preload("res://Assets/SFX/Coin2.wav")
	],
	'Bubble': [
		preload("res://Assets/SFX/BubblePop0.wav"),
		preload("res://Assets/SFX/BubblePop1.wav")
	],
	'Jump': [
		preload("res://Assets/SFX/Jump0.wav"),
		preload("res://Assets/SFX/Jump1.wav"),
		preload("res://Assets/SFX/Jump2.wav"),
		preload("res://Assets/SFX/Jump3.wav")
	],
	'Death': preload("res://Assets/SFX/Death.wav"),
	'Dash': preload("res://Assets/SFX/Dash.wav"),
	'Moon': preload("res://Assets/SFX/Moon.wav"),
	'MenuSwap': preload("res://Assets/SFX/MenuSwap.wav"),
	'MenuAccept': preload("res://Assets/SFX/MenuAccept.wav"),
	'RocketCharge': preload("res://Assets/SFX/RocketCharge.wav"),
	'RocketLaunch': preload("res://Assets/SFX/RocketLaunch.wav"),
	'Checkpoint': preload("res://Assets/SFX/Checkpoint.wav")
}
func play_sound(sound_name : String, ignore_type : int) -> SCSound:
	var sound : SCSound
	match ignore_type:
		SoundIgnoreType.IGNORE:
			sound = get_sound(sound_name)
			add_child(sound)
			sound.play()
		SoundIgnoreType.REPLACE:
			var the_sound : SCSound
			for i in get_children():
				if i.sound_name == sound_name:
					the_sound = i
			if the_sound == null:
				sound = get_sound(sound_name)
				add_child(sound)
				sound.play()
			else:
				sound = the_sound
				sound.play()
		SoundIgnoreType.PASS_THROUGH:
			var has_sound = false
			for i in get_children():
				if i.sound_name == sound_name:
					has_sound = true
			if has_sound == false:
				sound = get_sound(sound_name)
				add_child(sound)
				sound.play()
	return sound

func _process(_delta):
	for i in get_children():
		if !i.playing:
			remove_child(i)
			
func get_sound(sound_name : String):
	var stream = sound_data[sound_name]
	if stream is Array:
		stream = stream[randi_range(0,stream.size()-1)]
	var sound = SCSound.new(sound_name, stream)
	return sound
