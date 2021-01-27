extends Label

var showed = false

func play():
	if !showed:
		$AnimationPlayer.play('fade_in')
		showed = true
