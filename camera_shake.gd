extends Camera2D

export var CAMERA_SHAKE_DURATION = 0.6
export var CAMERA_SHAKE_AMPLITUDE = 2

onready var timer = $CameraShakeTimer

func _ready():
	set_process(false)
	timer.set_wait_time(CAMERA_SHAKE_DURATION)


func _process(delta):
	var damping = ease(timer.time_left / timer.wait_time, 1.0)
	offset = Vector2(
			rand_range(-CAMERA_SHAKE_AMPLITUDE, CAMERA_SHAKE_AMPLITUDE) * damping,
			rand_range(-CAMERA_SHAKE_AMPLITUDE, CAMERA_SHAKE_AMPLITUDE) * damping)


func shake_camera():
	timer.start()
	set_process(true)
	yield(timer, "timeout")
	set_process(false)