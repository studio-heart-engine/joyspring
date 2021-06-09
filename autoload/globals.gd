tool
extends Node

var has_played_startup_animation = false
var levels_completed = [0]
var curr_state = "Opening"
var prev_state = ""

var time_of_day = 0  # 0-indexed
var bg_num = 1  # 1-indexed
var bg_offset = 180  # Motion offset for parallax

var configurable_keys = ['up', 'down', 'left', 'right', 'dash', 'wall', 'float', 'swap']
var config_file
var keybinds = {}

func _ready():
	if not Engine.editor_hint:
		Events.connect('level_completed', self, 'on_level_completed')
		load_controls()
		set_controls()
		load_game()


func on_level_completed(level_index):
	if not level_index in levels_completed:
		levels_completed.append(level_index)

func save_game():
	var save = File.new()
	var data = {'levels_completed': levels_completed}
	save.open('user://game.save', File.WRITE)
	save.store_line(to_json(data))

func load_game():
	var save = File.new()
	if not save.file_exists('user://game.save'):
		return
	save.open('user://game.save', File.READ)
	var data = parse_json(save.get_line())
	levels_completed = data['levels_completed']

func load_controls():
	config_file = ConfigFile.new()
	if config_file.load('user://keybinds.ini') == OK:
		for key in config_file.get_section_keys('keybinds'):
			var value = config_file.get_value('keybinds', key)
			if str(value) != '':
				keybinds[key] = value
				print(value)
			else:
				keybinds[key] = null
	else:
		print('Warning: Missing keybinds config file, loading default controls')
		load_default_controls()
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
	for key in keybinds.keys():
		if keybinds[key] != null:
			config_file.set_value('keybinds', key, keybinds[key])
		else:
			config_file.set_value('keybinds', key, '')
	config_file.save('user://keybinds.ini')

func set_time_of_day():
	if curr_state.substr(0, 5) != 'Level':
		return
	if curr_state == 'LevelSelect':  # Done in level select script
		return
	var level_num = int(curr_state.right(5))
	set_time_of_day_from_num(level_num)

func set_time_of_day_from_num(num):
	if num < 10:
		time_of_day = 0
	elif num < 50:  # TODO
		time_of_day = 1
	else:
		time_of_day = 2

func set_bg():
	if curr_state.substr(0, 5) != 'Level':
		return
	if curr_state == 'LevelSelect':
		return
	var level_num = int(curr_state.right(5))
	if level_num < 5:
		bg_num = 1
	elif level_num < 10:
		bg_num = 2
	elif level_num < 13:
		bg_num = 3
	elif level_num < 40:
		bg_num = 4
	elif level_num < 50:  # TODO
		bg_num = 5
	elif level_num < 55:
		bg_num = 6
	else:
		bg_num = 7
	if level_num <= 14:  # Before and at peak
		bg_offset = 120 + 4 * (level_num - 1)  # Go from 180 to 240
	else:
		bg_offset = 240 - 4 * (level_num - 14)  # TODO: recalc using total level num, end at 120
