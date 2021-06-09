extends Label

export(String) var action

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect('keybind_changed', self, 'update_text')
	update_text()

func update_text():
	if action == 'swap':
		var keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = 'Press ' + keybind_text + ' to swap between layers.'
	if action == 'wall':
		var keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = 'Hold ' + keybind_text + ' to climb walls.'
	if action == 'wall jump':
		var keybind_text_1 = OS.get_scancode_string(globals.keybinds['wall'])
		var keybind_text_2 = OS.get_scancode_string(globals.keybinds['up'])
		var keybind_text_3a = OS.get_scancode_string(globals.keybinds['left'])
		var keybind_text_3b = OS.get_scancode_string(globals.keybinds['right'])
		self.text = 'Hold ' + keybind_text_1 + ', ' + keybind_text_2 + ', and ' + \
					keybind_text_3a + ' or ' + keybind_text_3b + ' to wall jump.'
	if action == 'dash':
		var keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = 'Hold a direction and press ' + keybind_text + \
					' to dash.\n Dash resets when you touch the ground.'
	if action == 'float':
		var keybind_text = OS.get_scancode_string(globals.keybinds[action])
		self.text = 'Hold ' + keybind_text + ' after dashing to float.'
