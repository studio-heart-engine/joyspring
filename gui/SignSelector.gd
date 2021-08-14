extends Node2D

var start = 1
var cur = 1
var signs = []
onready var camera

func _ready():
	for i in range(1, globals.total_levels + 1):
		signs.append(get_node('../LevelSigns/LevelSign' + str(i)))

func set_cur():
	signs[cur - 1].select()
	camera.position = signs[cur - 1].position - signs[start - 1].position

func _input(event):
	if event.is_action_pressed("left"):
		if cur == 1:
			return
		cur -= 1
		get_node("../Switch").update_time_and_bg()
		signs[cur].deselect()
		set_cur()
		$SoundEffect.play()
	elif event.is_action_pressed("right"):
		if cur == globals.total_levels:
			return
		if signs[cur].get_locked():
			return
		cur += 1
		get_node("../Switch").update_time_and_bg()
		signs[cur - 2].deselect()
		set_cur()
		$SoundEffect.play()
