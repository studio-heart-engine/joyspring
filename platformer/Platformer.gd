extends Node2D

export (PackedScene) var next_level
export (bool) var dash_enabled = true
export (bool) var float_enabled = true
export (bool) var climb_enabled = true
export (int) var level_index

signal level_exited

func _on_ExitArea_area_entered(area):
	SceneChanger.change_scene('res://gui/Menu.tscn')