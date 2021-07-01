tool
extends Node2D

#export (Texture) var texture
export (String) var shape

#var possible_colors = [
#	"#f82f68",
#	"#f82fa2",
#	"#e841cf"
#]
var possible_colors = [['#c97d54', '#c96254', '#d24b61', '#c9377b'],
					   ['#aee64d', '#83d464', '#57be7c', '#5aa98c'],
					   ['#9583dd', '#967ac9', '#8070be', '#6c6cba']]

func _ready():
	Events.connect('time_of_day_changed', self, 'update_image')
	update_image()
	
	for i in range(1, 5):
		get_node('Hitbox/CollisionPolygon2D_' + str(i)).disabled = true
		get_node('Hitbox/CollisionPolygon2D_' + str(i)).hide()
	print('Hitbox/CollisionPolygon2D_' + shape)
	get_node('Hitbox/CollisionPolygon2D_' + shape).disabled = false
	get_node('Hitbox/CollisionPolygon2D_' + shape).show()
		

var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

func update_image():
	$NoiseOffset/Outline.modulate = Color(possible_colors[globals.time_of_day][randi() % possible_colors.size()])
	$NoiseOffset/Outline.texture = load('res://graphics/sprites/blobs/' + get_time_of_day() + '/thorn' + shape + '.png')
	$NoiseOffset/Sprite.texture = load('res://graphics/sprites/blobs/' + get_time_of_day() + '/thorn' + shape + '.png')

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
