extends Node2D

export (String) var action = ""
export (float, 0, 2) var wait_time = 0.4

var done = false

signal resumed

func _ready():
	Events.connect(action, self, "resume")
	owner.connect('level_exited', self, 'resume')
	set_process(false)
	yield(get_tree().create_timer(wait_time), "timeout")
	set_process(true)
	$AnimationPlayer.play("slow")

func _process(delta):
	if not done:
		Engine.time_scale *= 0.9

func resume():
	if done:
		return
	done = true
	Engine.time_scale = 1
	$AnimationPlayer.play_backwards("slow")
	emit_signal("resumed")
