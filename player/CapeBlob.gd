extends KinematicBody2D

export (float) var WIND_SPEED = 40.0

func ready():
	rotation_degrees = randi() % 360
	var region_x = randi() % 3 * 8
	$Outline.region_rect.position.x = region_x
	$Sprite.region_rect.position.x = region_x

func follow(target_pos, min_dist, max_dist, speed):
	var diff = target_pos - position
	var dir = diff.normalized()
	var mag = diff.length()
	position += speed * (mag - min_dist) * dir
	diff = target_pos - position
	mag = diff.length()
	if mag > max_dist:
		position += (mag - max_dist) * dir

func _process(delta): 
	position.x += WIND_SPEED * delta * (1 if $"../../AnimatedSprite".flip_h else -1)