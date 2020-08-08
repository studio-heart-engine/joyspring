extends Control

export (bool) var has_level_select_button = false

func _ready():
	
	if len(globals.levels_completed) > 0:
		has_level_select_button = true
	
	if not has_level_select_button:
		$VBoxContainer/LevelSelectButton.queue_free()
	
	if not globals.has_played_startup_animation:
		globals.has_played_startup_animation = true
		$AnimationPlayer.play("fade-in")


func _input(event):
	if event.is_action_pressed("ui_select"):
		begin()


func _on_BeginButton_pressed():
	begin()
	

func begin():
	$AnimationPlayer.play("start-fall")
	yield($AnimationPlayer, "animation_finished")
	SceneChanger.change_scene("res://platformer/levels/Level_01.tscn")
	

func _on_LevelSelectButton_pressed():
	SceneChanger.change_scene("res://gui/LevelSelect.tscn")
