extends Control


func _ready():
	get_node('..').size = Vector2(320, 180)
	

func _input(event):
	if event.is_action_pressed("ui_select"):
		start()
#		SceneChanger.change_scene_to(load("res://gui/Menu.tscn"))

func _on_AnimationPlayer_animation_finished(anim_name):
	start()
#	SceneChanger.change_scene_to(load("res://gui/Menu.tscn"))

func play_opening():
	Events.emit_signal("play_legend_text", "opening")
	$AnimationPlayer.play("opening")

func play_ending():
	Events.emit_signal("play_legend_text", "ending")
	$AnimationPlayer.play("ending")

func start():
	var curr_level = globals.levels_completed[-1] + 1
	curr_level = str(curr_level).pad_zeros(2)
	if not File.new().file_exists('res://platformer/levels/Level_' + curr_level + '.tscn'):
		SceneChanger.change_scene_to(load('res://gui/LevelSelect.tscn'))
	else:
		SceneChanger.change_scene_to(load('res://platformer/levels/Level_' + curr_level + '.tscn'))
