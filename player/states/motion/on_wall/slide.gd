extends "../on_wall.gd"

export var WALL_SLIDE_SPEED = 40

func enter():
	.enter()
	owner.velocity.y = WALL_SLIDE_SPEED
	play_anim("slide")


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")


func handle_input(event):
	var input_direction = get_input_direction()
	var wall_direction = get_wall_direction()
	
	if input_direction.y == 0:
		emit_signal("finished", "cling")
	elif input_direction.y == -1:
		emit_signal("finished", "climb")
	
	if input_direction.x == -wall_direction:
		emit_signal("finished", "fall")
		return
	
	.handle_input(event)