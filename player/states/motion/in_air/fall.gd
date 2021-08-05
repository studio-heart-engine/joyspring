extends "../in_air.gd"

func enter():
	.enter()
#	owner.velocity.y = 0
	play_anim("fall")

func reenter():
	.reenter()
	play_anim("fall")
	anim_player.advance(1)

func update(delta):
	owner.velocity.y = min(owner.velocity.y + GRAVITY, TERMINAL_VELOCITY)
	owner.velocity.x = move_smoothly(
			owner.velocity.x, self.input_direction.x, MAX_IN_AIR_SPEED, IN_AIR_ACCELERATION)
	.update(delta)
