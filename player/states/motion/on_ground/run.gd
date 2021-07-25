extends "../on_ground.gd"

export var MAX_RUN_SPEED = 80

onready var sound_effect = $SoundEffect

onready var footsteps = [
	load("res://music/effects/footstep_1.wav"),
	load("res://music/effects/footstep_2.wav")
]

func enter():
	.enter()
	play_anim("run")

func update(delta):
	
	# TODO: depending on what owner.on_tile is, select tile type sound effect
#	if not sound_effect.is_playing():
#		sound_effect.set_stream(footsteps[randi() % len(footsteps)])
#		sound_effect.play()
	
	owner.velocity.x = move_smoothly(
			owner.velocity.x, self.input_direction.x, MAX_RUN_SPEED, ON_GROUND_ACCELERATION)
	if owner.velocity.x == 0:
		emit_signal("finished", "idle")
	.update(delta)

func handle_input(event):
	.handle_input(event)
	if sign(self.input_direction.x) == -sign(owner.velocity.x):
		spawn_skid_particles()
