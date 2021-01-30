extends Node

var has_played_startup_animation = false
var levels_completed = [0]
var curr_state

func _ready():
	Events.connect('level_completed', self, 'on_level_completed')
	load_game()


func on_level_completed(level_index):
	levels_completed.append(level_index)

func save_game():
	var save = File.new()
	var data = {'levels_completed': levels_completed}
	save.open('user://game.save', File.WRITE)
	save.store_line(to_json(data))

func load_game():
	var save = File.new()
	if not save.file_exists('user://game.save'):
		print('No save found')
		return
	save.open('user://game.save', File.READ)
	var data = parse_json(save.get_line())
	levels_completed = data['levels_completed']
	print('Save loaded')
