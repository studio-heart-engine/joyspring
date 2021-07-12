extends Node2D

export (float) var LOOP_TIME = 7

func _ready():
	$AnimationPlayer.playback_speed = 1.0 / LOOP_TIME
	
	if self.get_parent().get_parent().get_name() == 'Layer0':
		$Path2D/PathFollow2D/TileMap.collision_layer = pow(2, 4)
		$Path2D/PathFollow2D/TileMap.collision_mask = pow(2, 0)
		
		$Path2D/PathFollow2D/TileMap.light_mask = pow(2, 0)
		$Path2D/PathFollow2D/TileMap.occluder_light_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		$Path2D/PathFollow2D/TileMap.collision_layer = pow(2, 9)
		$Path2D/PathFollow2D/TileMap.collision_mask = pow(2, 5)
		
		$Path2D/PathFollow2D/TileMap.light_mask = pow(2, 5)
		$Path2D/PathFollow2D/TileMap.occluder_light_mask = pow(2, 5)
