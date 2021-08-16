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
var config_file
var keybinds = {}
var unique_jump = false  # true if jump is different from up

var cape = []
var joy_collected = []

var master_volume = 3

func _ready():
	if not Engine.editor_hint:
		Events.connect('level_completed', self, 'on_level_completed')
		Events.connect('joy_collected', self, 'on_joy_collected')
		for i in range(total_levels + 1):
			joy_collected.append([])
		for i in range(10):
			cape.append('normal')
		load_controls()
		set_controls()
		load_game()
		set_time_of_day()
		set_bg()


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
	
func load_controls():
	load_default_controls()
	config_file = ConfigFile.new()
	if config_file.load('user://keybinds.ini') == OK:
		for key in config_file.get_section_keys('keybinds'):
			var value = config_file.get_value('keybinds', key)
			if str(value) != '':
				keybinds[key] = value
			else:
				keybinds[key] = null
	save_controls()

func load_default_controls():
	for key in configurable_keys:
		var actionlist = InputMap.get_action_list(key)
		keybinds[key] = actionlist[0].scancode

func set_controls():
	for key in keybinds.keys():
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		if keybinds[key] != null:
			var new_value = InputEventKey.new()
			new_value.set_scancode(keybinds[key])
			InputMap.action_add_event(key, new_value)

func save_controls():
	if keybinds['up'] != keybinds['jump']:
		unique_jump = true
	else:
		unique_jump = false
	for key in keybinds.keys():
		if keybinds[key] != null:
			config_file.set_value('keybinds', key, keybinds[key])
		else:
			config_file.set_value('keybinds', key, '')
	config_file.save('user://keybinds.ini')

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
