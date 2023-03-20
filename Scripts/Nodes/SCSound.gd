extends AudioStreamPlayer
class_name SCSound

var sound_name : String = 'Coin'

func _init(_sound_name, _stream):
	sound_name = _sound_name
	stream = _stream

func _ready():
	connect('finished', finished)

func finished():
	playing = false
