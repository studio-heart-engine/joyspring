extends Camera2D

#export var CAMERA_SHAKE_DURATION = 0.3
#export var CAMERA_SHAKE_AMPLITUDE = 4

var duration = 0
var amplitude = 0

var is_shaking = false

onready var timer = $CameraShakeTimer

func _ready():
#	timer.set_wait_time(CAMERA_SHAKE_DURATION)
	Events.connect("player_dashed", self, "dash_shake")
	Events.connect("layer_swapped", self, "swap_shake")


func _physics_process(delta):
	if is_shaking:
		var damping = ease(timer.time_left / timer.wait_time, 1.0)
		offset = Vector2(
				rand_range(-amplitude, amplitude) * damping,
				rand_range(-amplitude, amplitude) * damping)

func dash_shake():
	duration = 0.3
	amplitude = 4
	shake_camera()

func swap_shake():
	duration = 0.2
	amplitude = 1
	shake_camera()

func shake_camera():
	timer.set_wait_time(duration)
	timer.start()
	is_shaking = true
	yield(timer, "timeout")
	is_shaking = false
