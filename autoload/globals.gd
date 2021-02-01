extends Node

var has_played_startup_animation = false
var levels_completed = [0]
var curr_state = "Opening"

var time_of_day = 0
var bg_num = 1
var bg_offset = 180  # Motion offset for parallax

func _ready():
	Events.connect('level_completed', self, 'on_level_completed')
	load_game()
	print(levels_completed)


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

func set_time_of_day():
	if curr_state.substr(0, 5) != 'Level':
		return
	if curr_state == 'LevelSelect':
		return
	var level_num = int(curr_state.right(5))
	if level_num < 10:
		time_of_day = 0
	elif level_num < 50:  # TODO
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
