extends Node2D

func _ready():
	position = $"../Player".position
	$AnimationPlayer.play(["dust3", "dust4"][randi() % 2])
	yield($AnimationPlayer, "animation_finished")
	queue_free()