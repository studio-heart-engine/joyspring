extends Node

onready var view_box = $ViewportContainer
onready var sub_viewport = $ViewportContainer/Viewport
onready var screen_res = get_viewport().size

var scaling = Vector2()


func _ready():
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling


func _process(delta):
	if sub_viewport.get_child(0):
		var children = sub_viewport.get_child(0).get_children()
		for child in children:
			if child.name.substr(0, 4) == "Text":
				var coord = child.get_global_transform_with_canvas().origin
				var path = "Text/Control/Label" + child.name.right(4)
				get_node(path).rect_position = coord * scaling