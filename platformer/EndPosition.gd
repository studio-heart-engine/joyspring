extends Position2D

export var RADIUS = 16

onready var player = $"../Player"

func _process(delta):
	if position.distance_to(player.position) <= RADIUS:
		SceneChanger.change_scene_to(get_parent().next_level)
		set_process(false)