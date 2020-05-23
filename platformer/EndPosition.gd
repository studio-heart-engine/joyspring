extends Position2D

export var RADIUS = 24

onready var player = get_parent().get_node("Player")

func _process(delta):
	if position.distance_to(player.position) <= RADIUS:
		SceneChanger.change_scene_to(get_parent().next_level)