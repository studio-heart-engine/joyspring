tool
extends TileMap

#enum TIME_OF_DAY {dawn, evening, midnight}
#
#export (TIME_OF_DAY) var time_of_day = TIME_OF_DAY.evening setget set_time_of_day

var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

var dynamic_tileset = load("res://graphics/tilesets/blobs_tileset_image.tres")

func _ready():
	Events.connect('time_of_day_changed', self, 'update_tileset')
	Events.connect('layer_swapped', self, 'check_collision')
	update_tileset()

func update_tileset():
	var tileset_image_path = "res://graphics/tilesets/" + get_time_of_day() + "/blobs.png"
	dynamic_tileset.image = load(tileset_image_path)

func check_collision():  # Check if player swapped layers into blob tile map
	var player_pos = get_node('../../Player').position
	var index1 = self.world_to_map(player_pos)  # Bottom half of player
	var index2 = self.world_to_map(player_pos + Vector2(0, -8))  # Top half of player
	var inside_tile = self.get_cellv(index1) == 0 or \
					  self.get_cellv(index2) == 0
#	print(player_pos)
#	print(str(index1) + ' ' + str(self.get_cellv(index1)))
#	print(str(index2) + ' ' + str(self.get_cellv(index2)))
	if inside_tile:
		Events.emit_signal('player_died', player_pos)
#		print('blob tile')

#func get_time_of_day():
#	return TIME_OF_DAY.keys()[time_of_day]
#
#func set_time_of_day(value):
#	time_of_day = value
#	update_tileset()
