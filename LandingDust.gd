extends Node2D

func _ready():
	position = $"../Player".position
	$AnimationPlayer.play(["dust1", "dust2"][randi() % 2])
	yield($AnimationPlayer, "animation_finished")
	queue_free()