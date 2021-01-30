extends Control


func _ready():
	$Label.text = name.right(6)

func highlight():
	$Label/AnimationPlayer.play('highlight')

func unhighlight():
	$Label/AnimationPlayer.play_backwards('highlight')
