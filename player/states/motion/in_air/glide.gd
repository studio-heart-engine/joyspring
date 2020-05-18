extends "../in_air.gd"

export var MAX_GLIDE_FALL_SPEED = 10
export var GLIDE_FALL_ACCELERATION = 2


func enter():
	glider.show()
	play_anim("glide")
	glider_anim_player.play("open")
	glider_anim_player.queue("glide")
	owner.velocity.y = max(owner.velocity.y, MAX_GLIDE_FALL_SPEED)


func reenter():
	glider.show()
	play_anim("glide")
	glider_anim_player.play("glide")
	owner.velocity.y = max(owner.velocity.y, MAX_GLIDE_FALL_SPEED)


func exit():
	glider.hide()
	glider_anim_player.stop()


func update(delta):
	owner.velocity.y = move_smoothly(
		owner.velocity.y, 1, MAX_GLIDE_FALL_SPEED, GLIDE_FALL_ACCELERATION)
	.update(delta)
	
	if is_near_floor():
		emit_signal("finished", "fall")


func handle_input(event):
	if event.is_action_pressed("glide"):
		emit_signal("finished", "fall")
