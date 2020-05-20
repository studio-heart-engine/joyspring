extends "../state.gd"

export var BLINK_TIME = 0.08

var blink_timer

func _ready():
	blink_timer = Timer.new()
	blink_timer.set_wait_time(BLINK_TIME)
	blink_timer.connect("timeout", self, "toggle_visible")
	add_child(blink_timer)

func enter():
	play_anim("idle")
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(10, 10, 10, 10)
	
	
	blink_timer.start()


func exit():
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(1, 1, 1, 1)
	blink_timer.stop()
	owner.sprite.visible = true


func toggle_visible():
	owner.sprite.visible = not owner.sprite.visible