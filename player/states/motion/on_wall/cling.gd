extends "../on_wall.gd"

func enter():
	.enter()
	play_anim("hang")

func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.x == -wall_direction:
		emit_signal("finished", "fall")
	elif self.input_direction.y != 0:
		emit_signal("finished", "climb")