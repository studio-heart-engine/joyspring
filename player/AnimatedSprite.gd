### behold, the scummiest workaround to ever exist ###

extends Node2D

export (bool) var flip_h = false

func _process(delta):
	if flip_h != (scale.x < 0):
		scale.x *= -1