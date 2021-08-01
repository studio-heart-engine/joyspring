tool
extends Node2D

export (bool) var START_RANDOMLY = false
export (float, 0, 1) var LOOP_START = 0

onready var path_follow = $Path2D/PathFollow2D
onready var blob = $Path2D/PathFollow2D/Blob
onready var blob_sprite = $Path2D/PathFollow2D/Blob/NoiseOffset/Sprite
onready var blob_outline = $Path2D/PathFollow2D/Blob/NoiseOffset/Outline

func _ready():
	var a = randi() % 360
	blob_sprite.rotation_degrees = a
	blob_outline.rotation_degrees = a
	$AnimationPlayer.seek(rand_range(0, 1) if START_RANDOMLY else LOOP_START)
	
	if self.get_parent().get_parent().get_name() == 'Layer0':
		$Path2D/PathFollow2D/Blob/Hitbox.collision_layer = pow(2, 1)
		$Path2D/PathFollow2D/Blob/Hitbox.collision_mask = pow(2, 0)
		
		$Path2D/PathFollow2D/Blob/NoiseOffset/Outline.light_mask = pow(2, 0)
		$Path2D/PathFollow2D/Blob/NoiseOffset/Sprite.light_mask = pow(2, 0)
	if self.get_parent().get_parent().get_name() == 'Layer1':
		$Path2D/PathFollow2D/Blob/Hitbox.collision_layer = pow(2, 6)
		$Path2D/PathFollow2D/Blob/Hitbox.collision_mask = pow(2, 5)
		
		$Path2D/PathFollow2D/Blob/NoiseOffset/Outline.light_mask = pow(2, 5)
		$Path2D/PathFollow2D/Blob/NoiseOffset/Sprite.light_mask = pow(2, 5)

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
	$AnimationPlayer.play("follow_loop")

func _process(delta):
	blob_sprite.rotation_degrees = -path_follow.rotation_degrees
	blob_outline.rotation_degrees = -path_follow.rotation_degrees
	
func set_collision(val):
	$Path2D/PathFollow2D/Blob.set_collision(val)
