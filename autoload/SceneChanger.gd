extends CanvasLayer


onready var color_rect = $ColorRect

signal scene_changed

func _ready():
	color_rect.set_visible(false)

#func change_scene(path: String, color = Color.black):
#	color_rect.color = color
#	color_rect.set_visible(true)
#	$AnimationPlayer.play("fade")
#	yield($AnimationPlayer, "animation_finished")
#	HDSceneChanger.change_scene(path)
#	call_deferred("emit_signal", "scene_changed")
#	$AnimationPlayer.play_backwards("fade")
#	yield($AnimationPlayer, "animation_finished")
#	color_rect.set_visible(false)

func change_scene_to(scene: PackedScene, color = Color.black):
	color_rect.color = color
	color_rect.set_visible(true)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	
	HDSceneChanger.change_scene_to(scene)
	globals.curr_state = scene.instance().get_name()
	globals.save_game()
	
	call_deferred("emit_signal", "scene_changed")
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
	color_rect.set_visible(false)

func reload_scene(color = Color.black):
	color_rect.color = color
	color_rect.set_visible(true)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	HDSceneChanger.reload_scene()
	call_deferred("emit_signal", "scene_changed")
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
	color_rect.set_visible(false)
