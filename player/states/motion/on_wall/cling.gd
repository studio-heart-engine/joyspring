extends "../on_wall.gd"

func enter():
	play_anim("hang")
	.enter()
	on_wall_timer.paused = false


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")
	if on_wall_timer.time_left < 1 and not on_wall_timer.is_stopped() and not blink_anim_player.is_playing():
		start_blink()


func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.y == -1:
		emit_signal("finished", "climb")
	elif self.input_direction.y == 1:
		emit_signal("finished", "slide")
	if self.input_direction.x == -wall_direction:
		if self.input_direction.y == -1:
			emit_signal("finished", "jump")
		else:
			emit_signal("finished", "fall")
	
