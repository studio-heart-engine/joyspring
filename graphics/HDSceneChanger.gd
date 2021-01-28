extends Node

export (PackedScene) var opening = preload('res://platformer/levels/Level_20.tscn')

var packed_current_scene
var current_scene


func _ready():
	current_scene = opening.instance()
	packed_current_scene = opening
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)

#func change_scene(path: String):
#	current_scene.queue_free()
#	current_scene = get_node(path).instance()
#	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)

func change_scene_to(scene: PackedScene):
	current_scene.queue_free()
	current_scene = scene.instance()
	packed_current_scene = scene
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
	
func reload_scene():
	change_scene_to(packed_current_scene)
