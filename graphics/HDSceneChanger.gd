extends Node

export (PackedScene) var opening = preload('res://platformer/PlatformerTemplate.tscn')

var current_scene


func _ready():
	for child in get_tree().get_root().get_children():
		print(child.get_name())
	
	current_scene = opening.instance()
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
#	sub_viewport.add_child(current_scene)

func change_scene(path: String):
	current_scene.queue_free()
	current_scene = get_node(path).instance()
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
#	sub_viewport.add_child(current_scene)	

func change_scene_to(scene: PackedScene):
	current_scene.queue_free()
	current_scene = scene.instance()
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
#	sub_viewport.add_child(current_scene)
	
