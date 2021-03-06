extends "../on_wall.gd"

export var WALL_SLIDE_SPEED = 40
onready var wall_slide_particles = preload("res://graphics/particles/WallSlideParticles.tscn")
var particles_instance

func enter():
	.enter()
	blink_anim_player.stop()
#	on_wall_timer.stop()
	on_wall_timer.paused = true
	player_sprite.visible = true
	if cape != null:
		cape.visible = true
	owner.velocity.y = WALL_SLIDE_SPEED
	play_anim("slide")
	particles_instance = wall_slide_particles.instance()
	player_sprite.add_child(particles_instance)


func exit():
	.exit()
	particles_instance.queue_free()


func update(delta):
	.update(delta)
	if not is_near_wall():
		emit_signal("finished", "fall")
	elif is_near_floor():
		emit_signal("finished", "idle")


func handle_input(event):
	.handle_input(event)
	
	if self.input_direction.x == -wall_direction:
		emit_signal("finished", "jump" if self.input_direction.y == -1 else "fall")
	elif self.input_direction.y == -1 and owner.can_wall_climb:
		emit_signal("finished", "climb")
