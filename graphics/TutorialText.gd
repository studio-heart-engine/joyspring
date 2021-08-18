extends Label

export(String) var action
var template_text

func _ready():
	if self.text != '':
		template_text = self.text
	Events.connect('keybind_changed', self, 'update_text')
	Events.connect('input_method_changed', self, "update_text")
	update_text()

func update_text():
	var controls
	if globals.using_controller:
		controls = globals.controller_controls
	else:
		controls = globals.keyboard_controls
	if action == 'swap':
		var keybind_text = 'Unassigned'
		if not controls[action] == null:
			keybind_text = get_control_text("swap")
		self.text = template_text.replace('[swap]', keybind_text)
	if action == 'wall':
		var keybind_text = 'Unassigned'
		if not controls[action] == null:
			keybind_text = get_control_text("wall")
		self.text = template_text.replace('[wall]', keybind_text)
	if action == 'wall jump':
		var keybind_text_1 = 'Unassigned'
		if not controls['wall'] == null:
			keybind_text_1 = get_control_text("wall")
		if globals.unique_jump:
			var keybind_text_2 = 'Unassigned'
			if not controls['jump'] == null:
				keybind_text_2 = get_control_text("jump")
			var new_text = template_text[1]
			new_text = new_text.replace('[wall]', keybind_text_1)
			new_text = new_text.replace('[jump]', keybind_text_2)
			self.text = new_text
		else:
			var keybind_text_2 = 'Unassigned'
			if not controls['up'] == null:
				keybind_text_2 = get_control_text("up")
			var keybind_text_3a = 'Unassigned'
			if not controls['left'] == null:
				keybind_text_2 = get_control_text("left")
			var keybind_text_3b = 'Unassigned'
			if not controls['right'] == null:
				keybind_text_2 = get_control_text("right")
			var new_text = template_text[0]
			new_text = new_text.replace('[wall]', keybind_text_1)
			new_text = new_text.replace('[up]', keybind_text_2)
			new_text = new_text.replace('[left]', keybind_text_3a)
			new_text = new_text.replace('[right]', keybind_text_3b)
			self.text = new_text
	if action == 'dash':
		var keybind_text = 'Unassigned'
		if not controls[action] == null:
			keybind_text = get_control_text("dash")
		self.text = template_text.replace('[dash]', keybind_text)
	if action == 'float':
		var keybind_text = 'Unassigned'
		if not controls[action] == null:
			keybind_text = get_control_text("float")
		self.text = template_text.replace('[float]', keybind_text)

func get_control_text(key):
	if globals.using_controller:
		if key in ["up", "down", "left", "right"]:
			return Input.get_joy_axis_string(globals.controller_controls[key])
		else:
			var ret = Input.get_joy_button_string(globals.controller_controls[key])
			if Input.get_joy_name(0) == 'XInput Gamepad':
				if ret in globals.XBOX_BUTTONS.keys():
					ret = globals.XBOX_BUTTONS[ret]
			return ret
	else:
		return OS.get_scancode_string(globals.keyboard_controls[key])
