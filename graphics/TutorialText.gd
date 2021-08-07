extends Label

export(String) var action
var template_text

func _ready():
	template_text = self.text
	Events.connect('keybind_changed', self, 'update_text')
	update_text()

func update_text():
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
		self.text = new_text
	if action == 'dash':
		var keybind_text = 'Unassigned'
		if not globals.keybinds[action] == null:
			keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = template_text.replace('[dash]', keybind_text)
	if action == 'float':
		var keybind_text = 'Unassigned'
		if not globals.keybinds[action] == null:
			keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = template_text.replace('[float]', keybind_text)
	if action == 'select':
		var keybind_text_1 = 'Unassigned'
		if not globals.keybinds['left'] == null:
			keybind_text_1 = OS.get_scancode_string(globals.keybinds['left'])
		var keybind_text_2 = 'Unassigned'
		if not globals.keybinds['right'] == null:
			keybind_text_2 = OS.get_scancode_string(globals.keybinds['right'])
		var keybind_text_3 = 'Unassigned'
		if not globals.keybinds['dash'] == null:
			keybind_text_3 = OS.get_scancode_string(globals.keybinds['dash'])
		var new_text = template_text
		new_text = new_text.replace('[left]', keybind_text_1)
		new_text = new_text.replace('[right]', keybind_text_2)
		new_text = new_text.replace('[dash]', keybind_text_3)
		self.text = new_text
