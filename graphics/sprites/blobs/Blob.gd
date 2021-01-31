tool

extends Node2D

#export (Texture) var texture
export (String) var shape

var possible_colors = [
	"#f82f68",
	"#f82fa2",
	"#e841cf"
]

func _ready():
	update_image()
	
	# Old code for setting texture
#	$NoiseOffset/Outline.texture = texture
#	$NoiseOffset/Sprite.texture = texture

	$NoiseOffset/Outline.modulate = Color(possible_colors[randi() % possible_colors.size()])


var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

func update_image():
	$NoiseOffset/Outline.texture = load('res://graphics/sprites/blobs/' + get_time_of_day() + '/blobs' + shape + '.png')
	$NoiseOffset/Sprite.texture = load('res://graphics/sprites/blobs/' + get_time_of_day() + '/blobs' + shape + '.png')

#enum TIME_OF_DAY {dawn, evening, midnight}
#
#export (TIME_OF_DAY) var time_of_day = TIME_OF_DAY.evening setget set_time_of_day

#
#func get_time_of_day():
#	return TIME_OF_DAY.keys()[time_of_day]
#
#func set_time_of_day(value):
#	time_of_day = value
#	update_image()
