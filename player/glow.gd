extends AnimationPlayer

func _ready():
	Events.connect("joy_collected", self, "glow")


func glow():
	stop()
	play("glow")