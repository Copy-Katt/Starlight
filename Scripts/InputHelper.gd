class_name InputHelper extends Node

const keycode_name_map := {
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

#const joypad_name_map := {
#	"Button": {
#		JoyButton.JOY_BUTTON_INVALID: "Invalid",
#		JoyButton.JOY_BUTTON_A: "↓ Button",
#		JoyButton.JOY_BUTTON_B: "→ Button",
#		JoyButton.JOY_BUTTON_X: "← Button",
#		JoyButton.JOY_BUTTON_Y: "↑ Button",
#		JoyButton.JOY_BUTTON_BACK: "Select",
#		JoyButton.JOY_BUTTON_GUIDE: "Home",
#		JoyButton.JOY_BUTTON_START: "Start",
#		JoyButton.JOY_BUTTON_LEFT_STICK: "Left Stick",
#		JoyButton.JOY_BUTTON_RIGHT_STICK: "Right Stick",
#		JoyButton.JOY_BUTTON_LEFT_SHOULDER: "L1",
#		JoyButton.JOY_BUTTON_RIGHT_SHOULDER: "R1",
#		JoyButton.JOY_BUTTON_DPAD_UP: "D-pad ↑",
#		JoyButton.JOY_BUTTON_DPAD_DOWN: "D-pad ↓",
#		JoyButton.JOY_BUTTON_DPAD_LEFT: "D-pad ←",
#		JoyButton.JOY_BUTTON_DPAD_RIGHT: "D-pad →",
#	},
#	"Axis": {
#		JoyAxis.JOY_AXIS_INVALID: ["Invalid", "Invalid"],
#		JoyAxis.JOY_AXIS_LEFT_X: ["LS-Left", "LS-Right"],
#		JoyAxis.JOY_AXIS_LEFT_Y: ["LS-Up", "LS-Down"],
#		JoyAxis.JOY_AXIS_RIGHT_X: ["RS-Left", "RS-Right"],
#		JoyAxis.JOY_AXIS_RIGHT_Y: ["RS-Up", "RS-Down"],
#		JoyAxis.JOY_AXIS_TRIGGER_LEFT: ["L2", "L2"],
#		JoyAxis.JOY_AXIS_TRIGGER_RIGHT: ["R2", "R2"]
#	}
#}
#const joypad_icon_map := {
#	"Button": {
#		JoyButton.JOY_BUTTON_INVALID: 0,
#		JoyButton.JOY_BUTTON_A: 7,
#		JoyButton.JOY_BUTTON_B: 6,
#		JoyButton.JOY_BUTTON_X: 8,
#		JoyButton.JOY_BUTTON_Y: 5,
#		JoyButton.JOY_BUTTON_BACK: 9,
#		JoyButton.JOY_BUTTON_GUIDE: 10,
#		JoyButton.JOY_BUTTON_START: 11,
#		JoyButton.JOY_BUTTON_LEFT_STICK: 12,
#		JoyButton.JOY_BUTTON_RIGHT_STICK: 17,
#		JoyButton.JOY_BUTTON_LEFT_SHOULDER: 22,
#		JoyButton.JOY_BUTTON_RIGHT_SHOULDER: 23,
#		JoyButton.JOY_BUTTON_DPAD_UP: 1,
#		JoyButton.JOY_BUTTON_DPAD_DOWN: 3,
#		JoyButton.JOY_BUTTON_DPAD_LEFT: 4,
#		JoyButton.JOY_BUTTON_DPAD_RIGHT: 2,
#	},
#	"Axis": {
#		JoyAxis.JOY_AXIS_INVALID: [0, 0],
#		JoyAxis.JOY_AXIS_LEFT_X: [16, 14],
#		JoyAxis.JOY_AXIS_LEFT_Y: [13, 15],
#		JoyAxis.JOY_AXIS_RIGHT_X: [21, 19],
#		JoyAxis.JOY_AXIS_RIGHT_Y: [18, 20],
#		JoyAxis.JOY_AXIS_TRIGGER_LEFT: [24, 24],
#		JoyAxis.JOY_AXIS_TRIGGER_RIGHT: [25, 25]
#	}
#}

static func name_from_keycode(keycode):
	if OS.get_keycode_string(keycode) in keycode_name_map.keys():
		return keycode_name_map[OS.get_keycode_string(keycode)]
	else:
		return OS.get_keycode_string(keycode)

#static func name_from_joypad(joy_input):
#	if joy_input[0] == 'Button':
#		return joypad_name_map.Button[joy_input[1]]
#	if joy_input[0] == 'Axis':
#		return joypad_name_map.Axis[joy_input[1]][joy_input[2]]
#
#static func icon_from_joypad(joy_input):
#	if joy_input[0] == 'Button':
#		return joypad_name_map.Button[joy_input[1]]
#	if joy_input[0] == 'Axis':
#		return joypad_name_map.Axis[joy_input.axis][(joy_input.axis_value+1)/2]
