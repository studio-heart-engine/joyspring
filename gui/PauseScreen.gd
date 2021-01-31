extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed('pause'):
		if get_tree().paused:
			resume()
		else:
			pause()


func _on_ResumeButton_pressed():
	$Click.play()
	resume()
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _on_MenuButton_pressed():
#	$Click.play()
#	get_parent().emit_signal('level_exited')
#	PlayerData.score = 0
#	SceneChanger.change_scene_to(load("res://gui/Menu.tscn"))
#	yield($"/root/SceneChanger/AnimationPlayer", "animation_finished")
#	resume()

func pause():
	$MarginContainer.show()
	get_tree().paused = true
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	$MarginContainer.hide()
	get_tree().paused = false

func _on_Level_Select_pressed():
	$Click.play()
	get_parent().emit_signal('level_exited')
	PlayerData.score = 0
	SceneChanger.change_scene_to(load("res://gui/LevelSelect.tscn"))
	yield($"/root/SceneChanger/AnimationPlayer", "animation_finished")
	resume()
