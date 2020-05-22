tool
extends Node2D

export (PackedScene) var next_level

func _get_configuration_warning():
	return "Next Level property can't be empty!" if not next_level else ""