extends Position2D

var noise
var t1 = 0
var t2 = 0

func _ready():
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 20.0

func _process(delta):
	position = 0.3 * Vector2(noise.get_noise_2d(t1, 0) - 0.5, noise.get_noise_2d(0, t2) - 0.5)
	t1 += 1.3
	t2 += 1.3