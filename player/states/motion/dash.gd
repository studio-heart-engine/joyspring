extends "../motion.gd"

export var DASH_SPEED = 300
export var MAX_DASH_TIME = 0.2

var direction
var timer

func enter():
	play_anim("idle")
	owner.can_dash = false
	direction = get_input_direction().normalized()
	timer = Timer.new()
	timer.set_wait_time(MAX_DASH_TIME)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "finish")
	add_child(timer)
	timer.start()
	

func update(delta):
	if owner.move_and_collide(direction * DASH_SPEED * delta):
		finish()

func finish():
	timer.stop()
	emit_signal("finished", "fall")