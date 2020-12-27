extends Node

var has_played_startup_animation = false
var levels_completed = [0]

func _ready():
	Events.connect('level_completed', self, 'on_level_completed')


func on_level_completed(level_index):
	levels_completed.append(level_index)