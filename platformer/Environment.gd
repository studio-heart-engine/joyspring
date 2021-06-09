tool
extends Node2D


var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func _ready():
	update_image()

func _process(delta):
	update_image()

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

func update_image():
	for child in self.get_children():
		child.set_texture(load('res://graphics/environment/' + get_time_of_day() + '/' + child.name.to_lower() + '.png'))
