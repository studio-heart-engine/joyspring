tool
extends Node

var has_played_startup_animation = false
var levels_completed = [0]
var curr_state = "Legend-Opening"
var prev_state = ""
var total_levels = 50
var peak_level = 12
var started_peak_zoom = false
var finished_peak_zoom = false
var start_level = -1

var time_of_day = 0  # 0-indexed
var time_of_day_start = [0, 10, 39]
var bg_num = 1  # 1-indexed
var bg_num_start = [0, 5, 10, 19, 28, 39, 44]
var bg_offset = 320  # Motion offset for parallax

var configurable_keys = ['jump', 'up', 'down', 'left', 'right', 'dash', 'wall', 'float', 'swap']
var keyboard_controls = {}
var controller_controls = {}
var unique_jump = false  # true if jump is different from up
var using_controller = false

var cape = []
var joy_collected = []

var master_volume = 3

var XBOX_BUTTONS = {
	"Face Button Top": "Y",
	"Face Button Right": "B",
	"Face Button Left": "X",
	"Face Button Bottom": "A",
	"R": "Right Trigger",
	"L": "Left Trigger"
}
var PS4_BUTTONS = {
	"Face Button Top": "Triangle",
	"Face Button Right": "Circle",
	"Face Button Left": "Square",
	"Face Button Bottom": "Cross"
}
var joystick_axis = {
	"up": 1,
	"down": 1,
	"left": 0,
	"right": 0
}
var joystick_axis_value = {
	"up": -1.0,
	"down": 1.0,
	"left": -1.0,
	"right": 1.0
}

func _ready():
	if not Engine.editor_hint:
		Events.connect('level_completed', self, 'on_level_completed')
		Events.connect('joy_collected', self, 'on_joy_collected')
		Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
		for i in range(total_levels + 1):
			joy_collected.append([])
		for i in range(10):
			cape.append('normal')
		if len(Input.get_connected_joypads()) > 0:
			using_controller = true

		for key in configurable_keys:
			var actionlist = InputMap.get_action_list(key)
			keyboard_controls[key] = actionlist[0].scancode
			if key in ["up", "down", "left", "right"]:
				controller_controls[key] = "IMMUTABLE"
			else:
				controller_controls[key] = actionlist[1].button_index
		save_controls('user://keybinds_default.ini')
		load_default_controls()
		load_controls()
		set_controls()
		load_game()
		set_time_of_day()
		set_bg()
		Events.emit_signal("input_method_changed")


func on_level_completed(level_index):
	if not level_index in levels_completed:
		levels_completed.append(level_index)

func on_joy_collected(joy_name):
	if not joy_name in joy_collected[int(curr_state.right(6))]:
		joy_collected[int(curr_state.right(6))].append(joy_name)

func save_game():
	var save = File.new()
	var data = {'levels_completed': levels_completed,
			'cape': cape,
			'joy_collected': joy_collected,
			'master_volume': master_volume,
			'version': 'release'}
	if curr_state.left(6) == 'Level_':
		data['curr_level'] = curr_state.right(6)
	save.open('user://game.save', File.WRITE)
	save.store_line(to_json(data))
	save.close()

func load_game():
	var save = File.new()
	if not save.file_exists('user://game.save'):
		return
	save.open('user://game.save', File.READ)
	if save.eof_reached():
		return
	var line = save.get_line()
	if line == '':
		return
	var data = parse_json(line)
	save.close()
	if not data.has('version'):
		var new_save = File.new()
		new_save.open('user://game_demo.save', File.WRITE)
		new_save.store_line(to_json(data))
		new_save.close()
		return
	if data.has('levels_completed'):
		levels_completed = data['levels_completed']
	if data.has('cape'):
		cape = []
		cape = data['cape']
	if data.has('joy_collected'):
		joy_collected = data['joy_collected']
		while len(joy_collected) < total_levels + 1:
			joy_collected.append([])
	if data.has('master_volume'):
		master_volume = int(data['master_volume'])
	if data.has('curr_level'):
		start_level = int(data['curr_level'])

func reset_game():
	var dir = Directory.new()
	if dir.file_exists('user://game.save'):
		dir.remove('user://game.save')
	Events.emit_signal('quit_game')
	
func load_controls(config_filepath='user://keybinds.ini'):
	var config_file = ConfigFile.new()
	if config_file.load(config_filepath) == OK:
		for key in config_file.get_section_keys('keyboard_controls'):
			var value = config_file.get_value('keyboard_controls', key)
			if str(value) != '':
				keyboard_controls[key] = value
			else:
				keyboard_controls[key] = null
		for key in config_file.get_section_keys('controller_controls'):
			var value = config_file.get_value('controller_controls', key)
			if str(value) != '':
				if key in ["up", "down", "left", "right"]:
					controller_controls[key] = "IMMUTABLE"
				else:
					controller_controls[key] = value
			else:
				controller_controls[key] = null
	save_controls()

func load_default_controls():
	load_controls('user://keybinds_default.ini')

func set_controls():
	if using_controller:
		for key in controller_controls.keys():
			var actionlist = InputMap.get_action_list(key)
			InputMap.action_erase_events(key)
			if controller_controls[key] != null:
				if key in ["up", "down", "left", "right"]:
					var new_value = InputEventJoypadMotion.new()
					new_value.set_axis(joystick_axis[key])
					new_value.set_axis_value(joystick_axis_value[key])
					InputMap.action_add_event(key, new_value)
				else:
					var new_value = InputEventJoypadButton.new()
					new_value.set_button_index(controller_controls[key])
					InputMap.action_add_event(key, new_value)
	else:
		for key in keyboard_controls.keys():
			var actionlist = InputMap.get_action_list(key)
			InputMap.action_erase_events(key)
			if keyboard_controls[key] != null:
				var new_value = InputEventKey.new()
				new_value.set_scancode(keyboard_controls[key])
				InputMap.action_add_event(key, new_value)

func save_controls(config_filepath='user://keybinds.ini'):
	var controls
	if using_controller:
		controls = controller_controls
		unique_jump = true
	else:
		controls = keyboard_controls
		if controls['up'] != controls['jump']:
			unique_jump = true
		else:
			unique_jump = false
	var config_file = ConfigFile.new()
	if config_file.load(config_filepath) == OK:
		for key in keyboard_controls.keys():
			if keyboard_controls[key] != null:
				config_file.set_value('keyboard_controls', key, keyboard_controls[key])
			else:
				config_file.set_value('keyboard_controls', key, '')
		for key in controller_controls.keys():
			if controller_controls[key] != null:
				config_file.set_value('controller_controls', key, controller_controls[key])
			else:
				config_file.set_value('controller_controls', key, '')
		config_file.save(config_filepath)

func _on_joy_connection_changed(device_id, connected):
	if connected:
		using_controller = true
	else:
		using_controller = false
	load_controls()
	set_controls()
	Events.emit_signal("input_method_changed")

func update_joy_button_name(button_name):
	if Input.get_joy_name(0) == 'XInput Gamepad':
		if button_name in XBOX_BUTTONS.keys():
			return XBOX_BUTTONS[button_name]
	if Input.get_joy_name(0) == 'PS4 Controller':
		if button_name in PS4_BUTTONS.keys():
			return PS4_BUTTONS[button_name]

func set_time_of_day():
	if curr_state.substr(0, 5) != 'Level':
		return
	var level_num = int(curr_state.right(5))
	if level_num < time_of_day_start[1]:
		time_of_day = 0
	elif level_num < time_of_day_start[2]:
		time_of_day = 1
	else:
		time_of_day = 2
	Events.emit_signal('time_of_day_changed')

func set_bg():
	if curr_state.substr(0, 5) != 'Level':
		return
	var level_num = int(curr_state.right(5))
	if level_num < bg_num_start[1]:
		bg_num = 1
	elif level_num < bg_num_start[2]:
		bg_num = 2
	elif level_num < bg_num_start[3]:
		bg_num = 3
	elif level_num < bg_num_start[4]:
		bg_num = 4
	elif level_num < bg_num_start[5]:
		bg_num = 5
	elif level_num < bg_num_start[6]:
		bg_num = 6
	else:
		bg_num = 7
	if level_num <= 12:  # Before and at peak
		bg_offset = int(320 + (60 / peak_level) * level_num)  # 320 to 380
	else:
		bg_offset = int(380 - (100 / (total_levels - peak_level)) * (level_num - peak_level))  # 380 to 120
	Events.emit_signal('bg_num_changed')
