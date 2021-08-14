
extends Control

var curr_anim

func _ready():
	set_colors()
	Events.connect('time_of_day_changed', self, 'set_colors')

func set_colors():
	if globals.time_of_day == 0:
		curr_anim = 'highlight_evening'
		$TextureRect.modulate = Color('236060')
	if globals.time_of_day == 1:
		curr_anim = 'highlight_midnight'
		$TextureRect.modulate = Color('222039')
	if globals.time_of_day == 2:
		curr_anim = 'highlight_dawn'
		$TextureRect.modulate = Color('a53f1b')

func highlight():
	set_colors()
	$Label/AnimationPlayer.play(curr_anim)

func unhighlight():
	set_colors()
	$Label/AnimationPlayer.play_backwards(curr_anim)
