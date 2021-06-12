extends Label

export(String) var action
var template_text

func _ready():
	template_text = self.text
	Events.connect('keybind_changed', self, 'update_text')
	update_text()

func update_text():
	print('update')
	if action == 'swap':
		var keybind_text = 'Unassigned'
		if not globals.keybinds[action] == null:
			keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = template_text.replace('[swap]', keybind_text)
	if action == 'wall':
		var keybind_text = 'Unassigned'
		if not globals.keybinds[action] == null:
			keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = template_text.replace('[wall]', keybind_text)
	if action == 'wall jump':
		var keybind_text_1 = 'Unassigned'
		if not globals.keybinds['wall'] == null:
			keybind_text_1 = OS.get_scancode_string(globals.keybinds['wall'])
		var keybind_text_2 = 'Unassigned'
		if not globals.keybinds['up'] == null:
			keybind_text_2 = OS.get_scancode_string(globals.keybinds['up'])
		var keybind_text_3a = 'Unassigned'
		if not globals.keybinds['left'] == null:
			keybind_text_3a = OS.get_scancode_string(globals.keybinds['left'])
		var keybind_text_3b = 'Unassigned'
		if not globals.keybinds['right'] == null:
			keybind_text_3b = OS.get_scancode_string(globals.keybinds['right'])
		var new_text = template_text
		new_text = new_text.replace('[wall]', keybind_text_1)
		new_text = new_text.replace('[up]', keybind_text_2)
		new_text = new_text.replace('[left]', keybind_text_3a)
		new_text = new_text.replace('[right]', keybind_text_3b)
	if action == 'dash':
		var keybind_text = 'Unassigned'
		if not globals.keybinds[action] == null:
			keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = template_text.replace('[dash]', keybind_text)
#		self.text = 'Hold a direction and press ' + keybind_text + \
#					' to dash.\n Dash resets when you touch the ground.'
	if action == 'float':
		var keybind_text = 'Unassigned'
		if not globals.keybinds[action] == null:
			keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = template_text.replace('[float]', keybind_text)
