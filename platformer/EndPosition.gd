extends Position2D

export var RADIUS = 16

onready var player = $"../../Player"

func _process(delta):
	if position.distance_to(player.position) <= RADIUS:
		Events.emit_signal('level_completed', get_parent().get_parent().level_index)
#		SceneChanger.change_scene_to(get_parent().get_parent().next_level)
		SceneChanger.next_level(get_parent().get_parent().level_index)
		set_process(false)
