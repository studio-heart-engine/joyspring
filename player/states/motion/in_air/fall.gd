extends "../in_air.gd"

func enter():
	.enter()
	owner.velocity.y = 0
	play_anim("fall")

func reenter():
	.reenter()
	play_anim("fall")
	anim_player.advance(1)

func update(delta):
	owner.velocity.y += GRAVITY
	.update(delta)