extends Node2D

func _ready():
	$AnimationPlayer.play(["slide1", "slide2"][randi() % 2])
