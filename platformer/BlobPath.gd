tool
extends Path2D

onready var path_follow = $PathFollow2D
onready var Blob = preload("res://graphics/sprites/blobs/Blob.tscn")

export var push = false

func _ready():
	if self.name == 'BlobPath_Pushed':
		return
	if not Engine.editor_hint and not push:
		set_blobs()

func _process(delta):
	if self.name == 'BlobPath_Pushed':
		return
	if Engine.editor_hint and push:  # Adding nodes to tree permanently only works in _process
		set_blobs()

func set_blobs():
	var count = [2, 2]
	while path_follow.unit_offset < 1:
		var blob = Blob.instance()
		blob.shape = str(randi() % 2 + 1)
#		blob.rotation_degrees = path_follow.rotation_degrees
		blob.position = path_follow.position + self.position
		blob.name = "Blob" + blob.shape + "_" + str(count[int(blob.shape) - 1]).pad_zeros(2)
		count[int(blob.shape) - 1] += 1
		
		if not Engine.editor_hint and not push:
			get_parent().call_deferred('add_child', blob)
		elif Engine.editor_hint and push:
			get_parent().add_child(blob)
			blob.set_owner(get_tree().get_edited_scene_root())
		path_follow.offset += 8 + rand_range(-1, 1)
	if push:
		self.name = 'BlobPath_Pushed'
