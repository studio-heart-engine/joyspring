extends "../on_wall.gd"

export var WALL_CLIMB_SPEED = 30
export var INITIAL_WALL_JUMP_SPEED = 50

func enter():
	.enter()
	owner.velocity.y = -WALL_CLIMB_SPEED
	play_anim("climb")


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "jump")


func handle_input(event):
	var input_direction = get_input_direction()
	var wall_direction = get_wall_direction()
	
	if input_direction.y == 0:
		emit_signal("finished", "cling")
	elif input_direction.y == 1:
		emit_signal("finished", "slide")
	
	if input_direction.x == -wall_direction:
		owner.velocity.x = -wall_direction * INITIAL_WALL_JUMP_SPEED
		emit_signal("finished", "jump")
		return
	
	.handle_input(event)