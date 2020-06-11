extends KinematicBody2D

var y_velocity = 0

func follow(target_pos, radius, speed):
	var diff = target_pos - self.position
	diff = (diff.length() - radius) * diff.normalized()
	self.position += speed * diff

func _physics_process(delta):
	position.y += 0.3