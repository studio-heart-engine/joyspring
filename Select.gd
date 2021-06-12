extends Control


func _ready():
	$Label.text = name.right(6)
	$Label.rect_position = Vector2(0, 0)
	$Label.modulate = Color(1, 1, 1, 0.6)
	$Label/AnimationPlayer.set_assigned_animation('highlight')

func highlight():
	$Label/AnimationPlayer.play('highlight')

func unhighlight():
	$Label/AnimationPlayer.play_backwards('highlight')
