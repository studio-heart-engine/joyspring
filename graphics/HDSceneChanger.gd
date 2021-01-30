extends Node

export (PackedScene) var opening

onready var sub_viewport = $'/root/HDWrapper/ViewportContainer/Viewport'

var packed_current_scene
var current_scene


func _ready():
	current_scene = opening.instance()
	packed_current_scene = opening
	sub_viewport.add_child(current_scene)


func change_scene(scene: String):
	current_scene.queue_free()
	current_scene = load(scene).instance()
	packed_current_scene = scene
	sub_viewport.add_child(current_scene)

func change_scene_to(scene: PackedScene):
	current_scene.queue_free()
	current_scene = scene.instance()
	packed_current_scene = scene
	sub_viewport.add_child(current_scene)
	
func reload_scene():
	change_scene_to(packed_current_scene)
