extends Node

export (PackedScene) var opening = preload('res://graphics/Legend.tscn')
#export (PackedScene) var opening = preload('res://platformer/levels/Finished_Level_21.tscn')
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

	Events.connect('quit_game', self, 'free_scene')
	yield(get_tree().root, "ready")
	if current_scene.name == 'Legend':
		current_scene.play_opening()

func change_scene_to(scene: PackedScene):
	if current_scene:
		get_node('/root/HDWrapper/ViewportContainer/Viewport').remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scene.instance()
	packed_current_scene = scene
	globals.prev_state = globals.curr_state
	globals.curr_state = current_scene.get_name()
	if globals.curr_state == 'Legend':
		if globals.prev_state.left(5) == 'Level':
			globals.curr_state = 'Legend-Ending'
		else:
			globals.curr_state = 'Legend_Opening'
	get_node('/root/HDWrapper/ViewportContainer/Viewport').add_child(current_scene)
	
func reload_scene():
	change_scene_to(packed_current_scene)

func free_scene():
	current_scene.queue_free()
