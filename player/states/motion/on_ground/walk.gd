extends "../on_ground.gd"

export var MAX_WALK_SPEED = 15

func enter():
	.enter()
	play_anim("walk")

func exit():
	.exit()

func update(delta):
	owner.velocity.x = move_smoothly(
			owner.velocity.x, get_input_direction().x, MAX_WALK_SPEED, ON_GROUND_ACCELERATION)
	if owner.velocity.x == 0:
		emit_signal("finished", "idle")
	.update(delta)

func handle_input(event):
	if event.is_action_released("down"):
		emit_signal("finished", "run")
	.handle_input(event)