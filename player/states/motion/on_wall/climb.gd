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
	.handle_input(event)
	
	if self.input_direction.y == 0:
		emit_signal("finished", "cling")
	elif self.input_direction.y == 1:
		emit_signal("finished", "slide")
	
	if self.input_direction.x == -wall_direction:
		owner.velocity.x = -wall_direction * INITIAL_WALL_JUMP_SPEED
		emit_signal("finished", "jump")