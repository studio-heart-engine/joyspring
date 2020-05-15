extends Node2D

func _ready():
	$AnimationPlayer.play(["jump1", "jump2"][randi() % 2])
	$AnimationPlayer.get_animation($AnimationPlayer.current_animation).loop = false
	yield($AnimationPlayer, "animation_finished")
	queue_free()