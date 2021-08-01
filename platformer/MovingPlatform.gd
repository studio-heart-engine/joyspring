tool
extends Node2D


func _ready():

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
	var track = Animation.new()
	var idx = track.add_track(Animation.TYPE_VALUE)
	track.track_set_path(idx, "Path2D/PathFollow2D:unit_offset")
	track.length = path_time
	track.track_insert_key(0, 0, 0.0)
	track.track_insert_key(0, path_time, 1.0)
	track.loop = true
	$AnimationPlayer.add_animation("follow_loop", track)
	if not Engine.editor_hint:
		$AnimationPlayer.play("follow_loop")
	else:
		$AnimationPlayer.stop()
