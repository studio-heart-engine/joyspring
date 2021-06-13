extends Node2D

var past_time_of_day = globals.time_of_day
var past_bg_num = globals.bg_num

func _ready():
	update_time_and_bg()
	Events.emit_signal('time_of_day_changed')
	Events.emit_signal('bg_num_changed')

func _process(delta):
	update_time_and_bg()
	if globals.time_of_day != past_time_of_day:
		Events.emit_signal('time_of_day_changed')
	if globals.bg_num != past_bg_num:
		Events.emit_signal('bg_num_changed')
	past_time_of_day = globals.time_of_day
	past_bg_num = globals.bg_num

func update_time_and_bg():
	var closest = ''
	var closest_dist = pow(2, 63) - 1
	var player_pos = get_node('../Player').position + Vector2(0, -8)
	for child in get_node('../LevelSigns').get_children():
		if child.is_player_in_box:
			closest = child.name
			break
		if player_pos.distance_to(child.position + Vector2(0, -40)) < closest_dist:
			closest = child.name
			closest_dist = player_pos.distance_to(child.position + Vector2(0, -40))
	
	var closest_num = int(closest.right(9))
	if closest_num > globals.time_of_day_start[0]:
		globals.time_of_day = 0
	if closest_num > globals.time_of_day_start[1]:
		globals.time_of_day = 1
	if closest_num > globals.time_of_day_start[2]:
		globals.time_of_day = 2

	if closest_num > globals.bg_num_start[0]:
		globals.bg_num = 1
	if closest_num > globals.bg_num_start[1]:
		globals.bg_num = 2
	if closest_num > globals.bg_num_start[2]:
		globals.bg_num = 3
	if closest_num > globals.bg_num_start[3]:
		globals.bg_num = 4
	if closest_num > globals.bg_num_start[4]:
		globals.bg_num = 5
	if closest_num > globals.bg_num_start[5]:
		globals.bg_num = 6
	if closest_num > globals.bg_num_start[6]:
		globals.bg_num = 7
	
	return closest_num
