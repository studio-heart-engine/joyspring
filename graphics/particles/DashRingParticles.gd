extends Node2D

func init(input_direction):
	rotation_degrees = get_angle_to(input_direction) * 180 / PI
	var anim = ["dash1", "dash2"][randi() % 2]
	$AnimationPlayer.get_animation(anim).set_loop(false)
	$AnimationPlayer.play(anim)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
