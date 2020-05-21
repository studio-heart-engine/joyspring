extends Control


func _ready():
	if not globals.has_played_startup_animation:
		$AnimationPlayer.play("startup")
		globals.has_played_startup_animation = true


func _input(event):
	if event.is_action_pressed("ui_select"):
		SceneChanger.change_scene("res://PlatformerTemplate.tscn")


func _on_BeginButton_pressed():
	SceneChanger.change_scene("res://PlatformerTemplate.tscn")