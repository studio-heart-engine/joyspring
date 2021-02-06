extends Particles2D

func _process(delta):
	position.y = $"../Player".position.y
