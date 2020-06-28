extends Camera2D

export var CAMERA_SHAKE_DURATION = 0.3
export var CAMERA_SHAKE_AMPLITUDE = 4

var is_shaking = false

onready var timer = $CameraShakeTimer

func _ready():
	timer.set_wait_time(CAMERA_SHAKE_DURATION)
	Events.connect("player_dashed", self, "shake_camera")


func _process(delta):
	if is_shaking:
		var damping = ease(timer.time_left / timer.wait_time, 1.0)
		offset = Vector2(
				rand_range(-CAMERA_SHAKE_AMPLITUDE, CAMERA_SHAKE_AMPLITUDE) * damping,
				rand_range(-CAMERA_SHAKE_AMPLITUDE, CAMERA_SHAKE_AMPLITUDE) * damping)


func shake_camera():
	timer.start()
	is_shaking = true
	yield(timer, "timeout")
	is_shaking = false