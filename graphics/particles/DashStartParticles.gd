extends Node2D

func init(input_direction):
	rotation_degrees = get_angle_to(input_direction) * 180 / PI
	$AnimationPlayer.get_animation("dash-mid1").set_loop(false)

func _ready():
	$AnimationPlayer.play("dash-mid1")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
