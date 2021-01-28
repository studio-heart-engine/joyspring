extends Node

#export (PackedScene) var opening

onready var view_box = $ViewportContainer
onready var sub_viewport = $ViewportContainer/Viewport
onready var screen_res = get_viewport().size

var scaling = Vector2()
var show = []
#var current_scene


func _ready():
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling
	set_dialogue()
	
#	current_scene = opening.instance()
#	sub_viewport.add_child(current_scene)
	
func _process(delta):
	set_dialogue()
	print(show)
	$Text/Dialogue.check_dialogue(sub_viewport.get_child(0).get_name(), show)
	
func set_dialogue():
	show = []
	if sub_viewport.get_child(0):
		var children = sub_viewport.get_child(0).get_children()
		for child in children:
			if child.name.substr(0, 4) == "Text":
				var coord = child.get_global_transform_with_canvas().origin
				var path = "Text/Dialogue/Dialogue" + child.name.right(4)
				get_node(path).rect_position = coord * scaling
				show.append(child.get_name().right(4))
		for child in $Text/Dialogue.get_children():
			if child.get_name().substr(0, 8) != 'Dialogue':
				continue
			if child.get_name().right(8) in show:
				child.show()
			else:
				child.hide()
			

#func change_scene(path: String):
#	current_scene.queue_free()
#	current_scene = get_node(path).instance()
#	sub_viewport.add_child(current_scene)
#
#
#func change_scene_to(scene: PackedScene):
#	current_scene.queue_free()
#	current_scene = scene.instance()
#	sub_viewport.add_child(current_scene)
	
