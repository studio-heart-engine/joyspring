
extends Control

var curr_anim

func set_colors(time_of_day):
	if time_of_day == 0:
		curr_anim = 'highlight_evening'
		$TextureRect.modulate = Color('236060')
	if time_of_day == 1:
		curr_anim = 'highlight_midnight'
		$TextureRect.modulate = Color('222039')
	if time_of_day == 2:
		curr_anim = 'highlight_dawn'
		$TextureRect.modulate = Color('a53f1b')

func highlight():
	$Label/AnimationPlayer.play(curr_anim)

func unhighlight():
	$Label/AnimationPlayer.play_backwards(curr_anim)
