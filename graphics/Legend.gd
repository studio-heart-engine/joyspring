extends Control


func _ready():
	get_node('..').size = Vector2(320, 180)

func _input(event):
	if event.is_action_pressed("ui_select"):
		SceneChanger.change_scene_to(load("res://gui/Menu.tscn"))

func _on_AnimationPlayer_animation_finished(anim_name):
	SceneChanger.change_scene_to(load("res://gui/Menu.tscn"))

func play_opening():
	Events.emit_signal("play_legend_text", "opening")
	$AnimationPlayer.play("opening")

func play_ending():
	Events.emit_signal("play_legend_text", "ending")
	$AnimationPlayer.play("ending")
