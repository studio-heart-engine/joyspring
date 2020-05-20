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
	.handle_input(event)
	
	if self.input_direction.y == 0:
		emit_signal("finished", "cling")
	elif self.input_direction.y == -1:
		emit_signal("finished", "climb")
	
	if self.input_direction.x == -wall_direction:
		emit_signal("finished", "fall")