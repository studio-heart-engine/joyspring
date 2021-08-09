extends Node2D

func _ready():
	update_time_and_bg()

func update_time_and_bg():
	var closest_num = get_node("../SignSelector").cur
	if closest_num >= globals.time_of_day_start[0]:
		globals.time_of_day = 0
	if closest_num >= globals.time_of_day_start[1]:
		globals.time_of_day = 1
	if closest_num >= globals.time_of_day_start[2]:
		globals.time_of_day = 2

	if closest_num >= globals.bg_num_start[0]:
		globals.bg_num = 1
	if closest_num >= globals.bg_num_start[1]:
		globals.bg_num = 2
	if closest_num >= globals.bg_num_start[2]:
		globals.bg_num = 3
	if closest_num >= globals.bg_num_start[3]:
		globals.bg_num = 4
	if closest_num >= globals.bg_num_start[4]:
		globals.bg_num = 5
	if closest_num >= globals.bg_num_start[5]:
		globals.bg_num = 6
	if closest_num >= globals.bg_num_start[6]:
		globals.bg_num = 7

	Events.emit_signal('time_of_day_changed')
	Events.emit_signal('bg_num_changed')
