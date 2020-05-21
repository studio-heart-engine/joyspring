extends "../on_wall.gd"

export var WALL_SLIDE_SPEED = 40

func enter():
	.enter()
	on_wall_timer.stop()
	owner.velocity.y = WALL_SLIDE_SPEED
	play_anim("slide")


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")
	elif is_near_floor():
		emit_signal("finished", "idle")


func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.x == -wall_direction:
		emit_signal("finished", "fall")