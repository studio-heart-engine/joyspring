extends "../state.gd"

func enter():
	anim_player.stop(false)
	squish_stretch_player.stop()
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(10, 10, 10, 10)
	blink_anim_player.play("blink")


func exit():
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(1, 1, 1, 1)
	blink_anim_player.stop()


func toggle_visible():
	owner.sprite.visible = not owner.sprite.visible