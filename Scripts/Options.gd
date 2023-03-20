extends Node

var options = {
	'video': {
		'name': 'Video Settings',
		'settings': {
			'max_fps': {
				'name': 'Max Framerate',
				'type': 'num',
				'def_value': 60,
				'min': 10,
				'max': 250,
				'step': 10,
				'swaps': {
					'250': 'Inf'
				}
			},
			'vsync': {
				'name': 'V-Sync',
				'type': 'bool',
				'def_value': false
			},
			'window_scale': {
				'name': 'Window Scale',
				'type': 'num',
				'def_value': 2,
				'min': 1,
				'max': 4,
				'step': 1,
				'swaps': {
					'1': '1x',
					'2': '2x',
					'3': '3x',
					'4': '4x'
				}
			},
			'borderless': {
				'name': 'Borderless Window',
				'type': 'bool',
				'def_value': false
			},
			'fullscreen': {
				'name': 'Fullscreen',
				'type': 'bool',
				'def_value': false
			}
		}
	}
}

var saved := {}

func on_change(id, value):
	pass
