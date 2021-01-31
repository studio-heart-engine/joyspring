extends "../on_wall.gd"

export var WALL_CLIMB_SPEED = 30
export var INITIAL_WALL_JUMP_SPEED = 50

func enter():
	.enter()
	owner.velocity.y = self.input_direction.y * WALL_CLIMB_SPEED
	play_anim("climb-side")


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "jump" if input_direction.y == -1 else "fall")


func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.y == 0:
		emit_signal("finished", "cling")
	
	if self.input_direction.x == -wall_direction:
		if self.input_direction.y == -1:
			owner.velocity.x = -wall_direction * INITIAL_WALL_JUMP_SPEED
			emit_signal("finished", "jump")
		else:
			emit_signal("finished", "fall")
