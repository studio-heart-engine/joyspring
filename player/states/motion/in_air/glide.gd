extends "../in_air.gd"

export var MAX_GLIDE_FALL_SPEED = 20
export var GLIDE_FALL_ACCELERATION = 3
export var MAX_GLIDE_HORIZONTAL_SPEED = 90
export var GLIDE_HORIZONTAL_ACCELERATION = 3

func enter():
	if not owner.has_node("Cape"):
		emit_signal("finished", "previous")
		return
	.enter()
	Events.emit_signal("glide_started")
	#glider.show()
#	squish_stretch_player.play("squish")
	play_anim("glide")
#	glider_anim_player.play("open", -1, 1.3)
#	glider_anim_player.queue("glide")
	owner.velocity.y = max(owner.velocity.y, MAX_GLIDE_FALL_SPEED)


func reenter():
	.reenter()
	Events.emit_signal("glide_started")
#	glider.show()
	play_anim("glide")
#	glider_anim_player.play("glide")
	owner.velocity.y = max(owner.velocity.y, MAX_GLIDE_FALL_SPEED)


func exit():
#	glider.hide()
#	glider_anim_player.stop()
	Events.emit_signal("glide_ended")


func update(delta):
	owner.velocity.y = move_smoothly(
		owner.velocity.y, 1, MAX_GLIDE_FALL_SPEED, GLIDE_FALL_ACCELERATION)
	owner.velocity.x = move_smoothly(
		owner.velocity.x, input_direction.x, MAX_GLIDE_HORIZONTAL_SPEED, GLIDE_HORIZONTAL_ACCELERATION)
	.update(delta)
	if input_direction.x != 0:
		set_looking_right(input_direction.x == 1)
	
	if is_near_floor():
		emit_signal("finished", "fall")


func handle_input(event):
	.handle_input(event)
	if event.is_action_pressed("glide"):
		emit_signal("finished", "fall")
