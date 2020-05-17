extends CanvasLayer


onready var color_rect = $ColorRect

func _ready():
	color_rect.set_visible(false)


func change_scene(path):
	color_rect.set_visible(true)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
	color_rect.set_visible(false)