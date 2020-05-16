extends "../on_ground.gd"

func enter():
	.enter()
	play_anim("idle")

func exit():
	.exit()

func update(delta):
	if get_input_direction().x != 0:
		emit_signal("finished", "run")
	.update(delta)