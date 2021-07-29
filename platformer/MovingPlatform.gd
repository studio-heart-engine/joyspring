extends Node2D

export (float) var LOOP_TIME = 7

func _ready():
	$AnimationPlayer.playback_speed = 1.0 / LOOP_TIME
	
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
