extends StaticBody2D


func _on_Area2D_area_entered(area):
	$AnimationPlayer.play(["rock1", "rock2"][randi() % 2])
	$AnimationPlayer.get_animation($AnimationPlayer.current_animation).set_loop(false)
	yield($AnimationPlayer, "animation_finished")
	queue_free()

