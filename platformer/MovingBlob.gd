extends Node2D

export (float) var LOOP_TIME = 7
export (bool) var START_RANDOMLY = false
export (float, 0, 1) var LOOP_START = 0

onready var path_follow = $Path2D/PathFollow2D
onready var blob = $Path2D/PathFollow2D/Blob
onready var blob_sprite = $Path2D/PathFollow2D/Blob/NoiseOffset/Sprite
onready var blob_outline = $Path2D/PathFollow2D/Blob/NoiseOffset/Outline

func _ready():
	$AnimationPlayer.playback_speed = 1.0 / LOOP_TIME
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


func _process(delta):
	blob_sprite.rotation_degrees = -path_follow.rotation_degrees
	blob_outline.rotation_degrees = -path_follow.rotation_degrees
	
func set_collision(val):
	$Path2D/PathFollow2D/Blob.set_collision(val)
