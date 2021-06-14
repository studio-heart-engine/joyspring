extends Node

export (PackedScene) var opening = preload('res://graphics/Opening.tscn')
#export (PackedScene) var opening = preload('res://platformer/levels/Level_16.tscn')
#export (PackedScene) var opening = preload('res://platformer/PlatformerLayeredTemplate.tscn')
#export (PackedScene) var opening = preload('res://gui/LevelSelect.tscn')

var packed_current_scene
var current_scene


func _ready():
	current_scene = opening.instance()
	packed_current_scene = opening
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
	globals.curr_state = current_scene.get_name()
	globals.set_time_of_day()
	globals.set_bg()

func change_scene_to(scene: PackedScene):
	if current_scene:
		get_node('/root/HDWrapper/ViewportContainer/Viewport').remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scene.instance()
	packed_current_scene = scene
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
	
func reload_scene():
	change_scene_to(packed_current_scene)
