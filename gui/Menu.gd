extends Control


func _input(event):
	if event.is_action_pressed("ui_select"):
		begin()


func _on_BeginButton_pressed():
	begin()

func begin():
	$AnimationPlayer.play_backwards("startup")
	$AnimationPlayer.stop(false)
	$AnimationPlayer.play("start-fall")
	yield($AnimationPlayer, "animation_finished")
	SceneChanger.change_scene("res://platformer/levels/Level01.tscn")