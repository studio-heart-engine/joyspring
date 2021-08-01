tool
extends Node2D

#export (float) var LOOP_TIME = 7

func _ready():
#	$AnimationPlayer.playback_speed = 1.0 / LOOP_TIME
	
	var tilemap = $Path2D/PathFollow2D/TileMap
	tilemap.modulate = Color(0, 0, 0)
	tilemap.material = tilemap.material.duplicate()
	
	if self.get_parent().get_parent().get_name() == 'Layer0':
		tilemap.collision_layer = pow(2, 4)
		tilemap.collision_mask = pow(2, 0)
		
		tilemap.light_mask = pow(2, 0)
		tilemap.occluder_light_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		tilemap.collision_layer = pow(2, 9)
		tilemap.collision_mask = pow(2, 5)
		
		tilemap.light_mask = pow(2, 5)
		tilemap.occluder_light_mask = pow(2, 5)
	
	var path_len = $Path2D.curve.get_baked_length()
	var speed = 50
	var path_time = path_len / speed
	var animation = $AnimationPlayer.get_animation('follow-loop')
	animation.length = path_time
	animation.track_insert_key(0, path_time, 1)
