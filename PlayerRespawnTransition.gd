extends CanvasLayer

func on_player_died(position):
	self.position = position
	$AnimationPlayer.play("shrink-circle")
	yield($AnimationPlayer, "animation_finished")
	
	$AnimationPlayer.play_backwards("shrink-circle")