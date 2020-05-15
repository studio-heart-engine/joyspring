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