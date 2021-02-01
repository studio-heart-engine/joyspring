extends Control

var showed = false

onready var texts = [
	load("res://music/effects/text_1.wav"),
	load("res://music/effects/text_2.wav"),
	load('res://music/effects/text_3.wav')
]

func play(reverse=false):
	if not showed and not reverse:
		get_child(0).get_child(0).play('fade_in')
#		$Label/AnimationPlayer.play('fade_in')
		if name.begins_with("Dialogue"):
			$Label/SoundEffect.set_stream(texts[randi() % len(texts)])
			$Label/SoundEffect.play()
		showed = true
		
	if showed and reverse:
		get_child(0).get_child(0).play_backwards('fade_in')
#		$Label/AnimationPlayer.play_backwards('fade_in')
		showed = false
