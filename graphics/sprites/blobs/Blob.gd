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
	$NoiseOffset/Outline.material = $NoiseOffset/Outline.material.duplicate()
	$NoiseOffset/Sprite.material = $NoiseOffset/Sprite.material.duplicate()
	if self.get_parent().get_parent().get_name() == 'Layer0':
		$Hitbox.collision_layer = pow(2, 1)
		$Hitbox.collision_mask = pow(2, 0)
		
		$NoiseOffset/Outline.light_mask = pow(2, 0)
		$NoiseOffset/Sprite.light_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		$Hitbox.collision_layer = pow(2, 6)
		$Hitbox.collision_mask = pow(2, 5)
		
		$NoiseOffset/Outline.light_mask = pow(2, 5)
		$NoiseOffset/Sprite.light_mask = pow(2, 5)

func set_collision(val):
	$Hitbox/CollisionShape2D.disabled = (not val)

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
