extends "../in_air.gd"

export var INITIAL_JUMP_SPEED = 240

func enter():
	.enter()
	play_anim("jump")
	owner.velocity.y = -INITIAL_JUMP_SPEED

func reenter():
	.enter()
	play_anim("jump")
	anim_player.advance(1)

func exit():
	.exit()

func update(delta):
	owner.velocity.y += GRAVITY
	if owner.velocity.y >= 0:
		emit_signal("finished", "fall")
	.update(delta)