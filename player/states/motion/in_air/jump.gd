extends "../in_air.gd"

export var INITIAL_JUMP_SPEED = 240

func enter():
	.enter()
	play_anim("jump")
	squish_stretch_player.play("stretch")
	spawn_jump_particles()
	owner.velocity.y = -INITIAL_JUMP_SPEED

func reenter():
	.reenter()
	play_anim("jump")
	anim_player.advance(1)

func update(delta):
	owner.velocity.y += GRAVITY
	if owner.velocity.y >= 0:
		emit_signal("finished", "fall")
	.update(delta)