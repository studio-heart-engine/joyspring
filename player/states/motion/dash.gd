extends "../motion.gd"

export var DASH_SPEED = 300
export var MAX_DASH_TIME = 0.2

var direction
var timer

signal player_dashed

func enter():
	emit_signal("player_dashed")
	
	spawn_dash_start_particles()
	owner.can_dash = false
	
	direction = self.input_direction.normalized()
	if self.input_direction.x != 0:
		set_looking_right(self.input_direction.x == 1)
	
	anim_player.play("dash")
	anim_player.stop(false)
	if self.input_direction.x == 0:
		anim_player.advance(0)
	elif self.input_direction.y == -1:
		anim_player.advance(1)
	elif self.input_direction.y == 0:
		anim_player.advance(2)
	else:
		anim_player.advance(3)
	
	
	timer = Timer.new()
	timer.set_wait_time(MAX_DASH_TIME)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "finish")
	add_child(timer)
	timer.start()
	
	yield(get_tree().create_timer(0.07), "timeout")
	spawn_dash_ring_particles()

func exit():
	timer.stop()

func update(delta):
	owner.velocity = direction * DASH_SPEED
	if owner.move_and_collide(owner.velocity * delta):
		finish()

func finish():
	emit_signal("finished", "previous")