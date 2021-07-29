extends Particles2D

func _ready():
	self.light_mask = pow(2, 0) + pow(2, 5)

func _process(delta):
	position.y = $"../Player".position.y
