tool
extends TileMap

#enum TIME_OF_DAY {dawn, evening, midnight}
enum TILE_MATERIAL {dirt, grass, pebbles, rocks, stones, vines}

#export (TIME_OF_DAY) var time_of_day = TIME_OF_DAY.evening setget set_time_of_day
export (TILE_MATERIAL) var tile_material = TILE_MATERIAL.grass setget set_tile_material

var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

var dynamic_tileset = load("res://graphics/tilesets/foreground_tileset_image.tres")

func _ready():
	update_tileset()
	Events.connect('time_of_day_changed', self, 'update_tileset')


func update_tileset():
	var tileset_image_path = "res://graphics/tilesets/" + get_time_of_day() + "/" + get_tile_material() + ".png"
	dynamic_tileset.image = load(tileset_image_path)


#func get_time_of_day():
#	return TIME_OF_DAY.keys()[time_of_day]


func get_tile_material():
	return TILE_MATERIAL.keys()[tile_material]


#func set_time_of_day(value):
#	time_of_day = value
#	update_tileset()


func set_tile_material(value):
	tile_material = value
	update_tileset()
