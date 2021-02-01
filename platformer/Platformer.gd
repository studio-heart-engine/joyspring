extends Node2D

export (PackedScene) var next_level
export (bool) var dash_enabled = true
export (bool) var float_enabled = true
export (bool) var climb_enabled = true
var level_index setget , get_level_index

signal level_exited


func _ready():
	level_index = int(name.right(6))
	if globals.curr_state == 'LevelSelect':
		if globals.prev_state.substr(0, 5) == 'Level' and globals.prev_state != 'LevelSelect':
			$Player.position = get_node('LevelSign' + str(int(globals.prev_state.right(5)))).position
	set_bg()

func all_joys_collected():
	return $Joys.get_child_count() == 0


func get_level_index():
	return level_index


func _on_ExitArea_area_entered(area):
	SceneChanger.change_scene_to(load('res://gui/Menu.tscn'))



func set_bg():
	var image_path = "res://graphics/environment/background" + str(globals.bg_num) + ".tres"
	$ParallaxBackground/ParallaxLayer/background.set_texture(load(image_path))
	$ParallaxBackground/ParallaxLayer.motion_offset.y = globals.bg_offset
#	$Background/background.set_texture(load(image_path))
