tool
extends Node2D


var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func _ready():
	update_image()
	Events.connect('time_of_day_changed', self, 'update_image')
	
	if self.get_parent().get_name() == 'Layer0':
		for child in self.get_children():
			child.light_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		for child in self.get_children():
			child.light_mask = pow(2, 5)
		

func _process(delta):
	if Engine.editor_hint:
		update_image()

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

func update_image():
	for child in self.get_children():
		child.set_texture(load('res://graphics/environment/' + get_time_of_day() + '/' + child.name.to_lower() + '.png'))
