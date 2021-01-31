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
	update_tileset()

func update_tileset():
	var tileset_image_path = "res://graphics/tilesets/" + get_time_of_day() + "/blobs.png"
	dynamic_tileset.image = load(tileset_image_path)
#
#func get_time_of_day():
#	return TIME_OF_DAY.keys()[time_of_day]
#
#func set_time_of_day(value):
#	time_of_day = value
#	update_tileset()
