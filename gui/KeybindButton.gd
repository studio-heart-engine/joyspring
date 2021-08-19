extends Button

var key
var value
var menu

var waiting_input = false

func _ready():
	Events.connect("keybind_changed", self, "reload_value")

func _input(event):
	if waiting_input:
		if event is InputEventKey:
			value = event.scancode
			text = OS.get_scancode_string(value)
			menu.change_bind(key, value)
			pressed = false
			waiting_input = false
		elif event is InputEventJoypadButton:
			value = event.button_index
			text = Input.get_joy_button_string(value)
			set_face_button_name()
			menu.change_bind(key, value)
			pressed = false
			waiting_input = false
		elif event is InputEventMouseButton or event is InputEventJoypadMotion:
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
	text = globals.update_joy_button_name(text)

func reload_value():
	if text.left(13) == 'Left Joystick':
		return
	if globals.using_controller:
		value = globals.controller_controls[key]
		if value == null:
			text = 'Unassigned'
		else:
			text = Input.get_joy_button_string(value)
			set_face_button_name()
	else:
		value = globals.keyboard_controls[key]
		if value == null:
			text = 'Unassigned'
		else:
			text = OS.get_scancode_string(value)
