extends CanvasLayer

func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
			# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			pause()

func _on_ResumeButton_pressed():
	resume()
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_MenuButton_pressed():
	PlayerData.score = 0
	SceneChanger.change_scene("res://gui/Menu.tscn")
	yield($"/root/SceneChanger/AnimationPlayer", "animation_finished")
	resume()

func pause():
	$MarginContainer.show()
	get_tree().paused = true
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	$MarginContainer.hide()
	get_tree().paused = false