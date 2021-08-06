extends Path2D

onready var path_follow = $PathFollow2D
onready var Blob = preload("res://graphics/sprites/blobs/Blob.tscn")

func _ready():
	while path_follow.unit_offset < 1:
		var blob = Blob.instance()
		blob.shape = str(randi() % 3 + 1)
		blob.rotation_degrees = path_follow.rotation_degrees
		blob.position = path_follow.position + self.position
		
		get_parent().call_deferred('add_child', blob)
		path_follow.offset += 8
