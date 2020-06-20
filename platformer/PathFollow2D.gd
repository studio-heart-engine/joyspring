extends PathFollow2D

onready var blob = $Blob

func _process(delta):
	var a = rotation_degrees
	blob.rotation_degrees = -a