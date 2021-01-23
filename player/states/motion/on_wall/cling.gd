extends "../on_wall.gd"

func enter():
	.enter()
	play_anim("hang")
	on_wall_timer.start()


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")


func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.x == -wall_direction:
		if self.input_direction.y == -1:
			emit_signal("finished", "jump")
		else:
			emit_signal("finished", "fall")
	
