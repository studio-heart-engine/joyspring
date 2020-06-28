extends Node

export (String) var action = ""
export (float, 0, 2) var wait_time = 0.4

var done = false

func _ready():
	Events.connect(action, self, "resume")
	set_process(false)
	yield(get_tree().create_timer(wait_time), "timeout")
	set_process(true)

func _process(delta):
	if not done:
		Engine.time_scale *= 0.9

func resume():
	done = true
	Engine.time_scale = 1