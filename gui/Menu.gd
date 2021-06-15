extends Control

export (bool) var has_level_select_button = false

onready var begun = false

func _ready():
	
	if len(globals.levels_completed) > 1:
		has_level_select_button = true
	
#	if not has_level_select_button:
#	if has_level_select_button:
#		$VBoxContainer/LevelSelectButton.queue_free()
	
	if not globals.has_played_startup_animation:
		globals.has_played_startup_animation = true
		$AnimationPlayer.play("fade-in")
		$Mountain/AnimationPlayer.play('Loop')


func _input(event):
	if event.is_action_pressed("ui_select"):
		$Click.play()
		begin()

#func _on_BeginButton_pressed():
#	begin()
	
func begin():
	if begun:
		return
	begun = true
	$Mountain.modulate = Color(1, 1, 1, 1)
	$AnimationPlayer.play("start-fall")
	globals.curr_state = 'MenuTransition'
	yield($AnimationPlayer, "animation_finished")
	
	var curr_level = globals.levels_completed[-1] + 1
	curr_level = str(curr_level).pad_zeros(2)
	if not File.new().file_exists('res://platformer/levels/Level_' + curr_level + '.tscn'):
		SceneChanger.change_scene_to(load('res://gui/LevelSelect.tscn'))
	else:
		SceneChanger.change_scene_to(load('res://platformer/levels/Level_' + curr_level + '.tscn'))
	

func _on_LevelSelectButton_pressed():
	SceneChanger.change_scene("res://gui/LevelSelect.tscn")
