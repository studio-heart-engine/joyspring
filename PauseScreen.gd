extends CanvasLayer

func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused: resume()
		else: pause()

func _on_ResumeButton_pressed():
	resume()


func _on_MenuButton_pressed():
	PlayerData.score = 0
	SceneChanger.change_scene("res://Menu.tscn")
	yield($"/root/SceneChanger/AnimationPlayer", "animation_finished")
	resume()

func pause():
	$MarginContainer.show()
	get_tree().paused = true

func resume():
	$MarginContainer.hide()
	get_tree().paused = false