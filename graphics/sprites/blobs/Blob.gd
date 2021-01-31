tool

extends Node2D

#export (Texture) var texture
export (String) var shape

#var possible_colors = [
#	"#f82f68",
#	"#f82fa2",
#	"#e841cf"
#]
var possible_colors = [['#e96254', '#da4863', '#cb3660', '#b92e6f'],
					   ['#e5be48', '#e5b841', '#e5ae34', '#e1a83c'],
					   ['#9583dd', '#967ac9', '#8070be', '#6c6cba']]

func _ready():
	update_image()



var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

func update_image():
	$NoiseOffset/Outline.modulate = Color(possible_colors[globals.time_of_day][randi() % possible_colors.size()])
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
