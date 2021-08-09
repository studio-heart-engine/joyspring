extends Node2D

export (int) var SPACING = 8
#export (int) var THORN_SPACING = 30
#export (bool) var HAS_THORNS = false

onready var path_follow = $Path2D/PathFollow2D
onready var Blob = preload("res://graphics/sprites/blobs/Blob.tscn")
#onready var Thorn = preload("res://graphics/sprites/blobs/Thorn.tscn")

func _ready():
	
	while path_follow.unit_offset < 1:
		var blob = Blob.instance()
		blob.shape = str(randi() % 3 + 1)
		blob.rotation_degrees = path_follow.rotation_degrees + rand_range(-20, 20)
		blob.position = path_follow.position + self.position
		
		get_parent().call_deferred('add_child', blob)
		path_follow.offset += SPACING
