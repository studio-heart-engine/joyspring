extends Control

func _on_BeginButton_pressed():
	SceneChanger.change_scene("res://PlatformerTemplate.tscn")


func _on_AboutButton_pressed():
	SceneChanger.change_scene("res://About.tscn")


func _on_MoreButton_pressed():
	SceneChanger.change_scene("res://More.tscn")
