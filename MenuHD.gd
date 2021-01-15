extends Node

onready var view_box = $ViewportContainer
onready var sub_viewport = $ViewportContainer/Viewport
onready var screen_res = get_viewport().size

var scaling = Vector2()

func _ready():
	scaling = screen_res / sub_viewport.size
	view_box.rect_scale = scaling
