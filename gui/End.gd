extends Control

onready var begun = false

func _ready():
	get_node('..').size = Vector2(320, 180)

	$AnimationPlayer.play("fade-in")
	$Mountain/AnimationPlayer.play('Loop')


func _input(event):
	if event.is_action_pressed("ui_select"):
		globals.curr_state = 'EndTransition'
		begin()


func begin():
	if begun:
		return
	begun = true
	$Mountain.modulate = Color(1, 1, 1, 1)
	$AnimationPlayer.play("start-fall")
	yield($AnimationPlayer, "animation_finished")
	
	SceneChanger.change_scene_to(load('res://platformer/levels/Level_01.tscn'))
