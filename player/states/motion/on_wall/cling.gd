extends "../on_wall.gd"

func enter():
	.enter()
	play_anim("hang")

func handle_input(event):
	.handle_input(event)
	
	var input_direction = get_input_direction()
	
	if input_direction.x == -wall_direction:
		emit_signal("finished", "fall")
		return
	
	if input_direction.y == -1:
		emit_signal("finished", "climb")
	elif input_direction.y == 1:
		emit_signal("finished", "slide")