extends Control

func _on_AnimationPlayer_animation_finished(anim_name):
	SceneChanger.change_scene("res://gui/Menu.tscn")
