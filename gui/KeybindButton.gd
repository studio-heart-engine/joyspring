extends Button

var key
var value
var menu

var waiting_input = false

var XBOX_BUTTONS = {
	"Face Button Top": "Y",
	"Face Button Right": "B",
	"Face Button Left": "X",
	"Face Button Bottom": "A"
}
var PS4_BUTTONS = {
	"Face Button Top": "Triangle",
	"Face Button Right": "Circle",
	"Face Button Left": "Square",
	"Face Button Bottom": "Cross"
}

func _input(event):
	if waiting_input:
		if event is InputEventKey:
			value = event.scancode
			text = OS.get_scancode_string(value)
			menu.change_bind(key, value)
			pressed = false
			waiting_input = false
#		elif event is InputEventJoypadButton:
#			value = event.button_index
#			text = Input.get_joy_button_string(value)
#			set_face_button_name()
#			menu.change_bind(key, value)
#			pressed = false
#			waiting_input = false
#		elif event is InputEventMouseButton or event is InputEventJoypadMotion:
		elif event is InputEventMouseButton:
			if value != null:
				if globals.using_controller:
					text = Input.get_joy_button_string(value)
					set_face_button_name()
				else:
					text = OS.get_scancode_string(value)
			else:
				text = 'Unassigned'
			pressed = false
			waiting_input = false

func _toggled(button_pressed):
	if button_pressed:
		waiting_input = true
		set_text('Press Any Key')

func set_face_button_name():
	if Input.get_joy_name(0) == 'XInput Gamepad':
		if text in XBOX_BUTTONS.keys():
			text = XBOX_BUTTONS[text]
