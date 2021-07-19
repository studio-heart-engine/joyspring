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
	globals.save_game()
	globals.set_time_of_day()
	globals.set_bg()

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

func next_level(curr_index, color=Color.black):
	color_rect.color = color
	color_rect.set_visible(true)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	
	var next_level_path = 'res://platformer/levels/Level_' + ('%02d' % (curr_index + 1)) + '.tscn'
	var scene
	if File.new().file_exists(next_level_path):
		scene = load(next_level_path)
	else:
		scene = load('res://gui/Menu.tscn')
	
	HDSceneChanger.change_scene_to(scene)
	globals.save_game()
	globals.set_time_of_day()
	globals.set_bg()

	call_deferred("emit_signal", "scene_changed")
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
	color_rect.set_visible(false)
