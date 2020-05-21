extends "../state.gd"

func enter():
	play_anim("idle")
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(10, 10, 10, 10)
	blink_anim_player.play("blink")


func exit():
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(1, 1, 1, 1)
	blink_anim_player.stop()


func toggle_visible():
	owner.sprite.visible = not owner.sprite.visible