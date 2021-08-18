extends Control

var mode = 'NULL'

func _ready():
	get_node('..').size = Vector2(320, 180)
	if globals.curr_state == 'Legend-Opening':
		play_opening()
	elif globals.curr_state == 'Legend-Ending':
		play_ending()

func _input(event):
	if event is InputEventKey and event.pressed:
		start()

func _on_AnimationPlayer_animation_finished(anim_name):
	start()

func play_opening():
	mode = 'opening'
	Events.emit_signal("play_legend_text", "opening")
	$AnimationPlayer.play("opening")

func play_ending():
	mode = 'ending'
	Events.emit_signal("play_legend_text", "ending")
	$AnimationPlayer.play("ending")

func start():
	$AnimationPlayer.stop(true)
	if mode == 'opening':
		if globals.start_level != -1:
			SceneChanger.change_scene_to(load('res://platformer/levels/Level_' + str(globals.start_level).pad_zeros(2) + '.tscn'))
		else:
			var curr_level = globals.levels_completed[-1] + 1
			curr_level = str(curr_level).pad_zeros(2)
			if not File.new().file_exists('res://platformer/levels/Level_' + curr_level + '.tscn'):
				SceneChanger.change_scene_to(load('res://platformer/levels/Level_50.tscn'))
			else:
				SceneChanger.change_scene_to(load('res://platformer/levels/Level_' + curr_level + '.tscn'))
	elif mode == 'ending':
		SceneChanger.change_scene_to(load('res://gui/End.tscn'))
