extends Node2D

func _ready():
	$SoundEffect.pitch_scale = 1 + rand_range(-0.3, 0.3)
	$SoundEffect.play()
	$AnimationPlayer.play(["fall1", "fall2"][randi() % 2])
	$AnimationPlayer.get_animation($AnimationPlayer.current_animation).loop = false
	yield($AnimationPlayer, "animation_finished")
	queue_free()
