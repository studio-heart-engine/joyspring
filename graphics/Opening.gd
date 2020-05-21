extends Control

func _input(event):
	if event.is_action_pressed("ui_select"):
		SceneChanger.change_scene("res://gui/Menu.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	SceneChanger.change_scene("res://gui/Menu.tscn")