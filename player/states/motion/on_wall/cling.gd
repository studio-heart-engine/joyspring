extends "../on_wall.gd"

func enter():
	.enter()
	play_anim("hang")

func handle_input(event):
	var input_direction = get_input_direction()
	var wall_direction = get_wall_direction()
	
	if input_direction.y == -1:
		emit_signal("finished", "climb")
	elif input_direction.y == 1:
		emit_signal("finished", "slide")
	
	if input_direction.x == -wall_direction:
		
		# prevent immediately clinging back to wall by moving away from it by 1 pixel
		owner.move_and_collide(Vector2(-wall_direction, 0)) 
		
		emit_signal("finished", "fall")
		return
	
	.handle_input(event)