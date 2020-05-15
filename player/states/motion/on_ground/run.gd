extends "../on_ground.gd"

export var MAX_RUN_SPEED = 50

func enter():
	.enter()
	play_anim("run")

func exit():
	.exit()

func update(delta):
	owner.velocity.x = move_smoothly(
			owner.velocity.x, get_input_direction().x, MAX_RUN_SPEED, ON_GROUND_ACCELERATION)
	if owner.velocity.x == 0:
		emit_signal("finished", "idle")
	.update(delta)

func handle_input(event):
	if event.is_action_pressed("down"):
		emit_signal("finished", "walk")
	.handle_input(event)