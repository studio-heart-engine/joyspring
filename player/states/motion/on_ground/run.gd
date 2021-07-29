extends "../on_ground.gd"

export var MAX_RUN_SPEED = 80

func enter():
	.enter()
	play_anim("run")

func update(delta):
	owner.velocity.x = move_smoothly(
			owner.velocity.x, self.input_direction.x, MAX_RUN_SPEED, ON_GROUND_ACCELERATION)
	if owner.velocity.x == 0:
		emit_signal("finished", "idle")
	.update(delta)

func handle_input(event):
	.handle_input(event)
	if sign(self.input_direction.x) == -sign(owner.velocity.x):
		spawn_skid_particles()
