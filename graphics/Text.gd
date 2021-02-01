extends Control

var showed = false

func play(reverse=false):
	if not showed and not reverse:
		get_child(0).get_child(0).play('fade_in')
#		$Label/AnimationPlayer.play('fade_in')
		if name.begins_with("Dialogue"):
			$Label/SoundEffect.play()
			print('asdfsadfafasdf')
		showed = true
		
	if showed and reverse:
		get_child(0).get_child(0).play_backwards('fade_in')
#		$Label/AnimationPlayer.play_backwards('fade_in')
		showed = false
