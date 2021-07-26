extends "../state.gd"

var input_direction = Vector2.ZERO

func enter():
	$SoundEffect.play()
	anim_player.stop(false)
	owner.find_node("GlowAnimationPlayer").stop()
	squish_stretch_player.stop()
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(10, 10, 10, 10)
	owner.get_node("Cape").modulate = Color(0, 0, 0, 0)
	start_blink()


func exit():
	owner.get_node("AnimatedSprite/Sprite").modulate = Color(1, 1, 1, 1)
	owner.get_node("Cape").modulate = Color(1, 1, 1, 1)
	
	blink_anim_player.stop()


func toggle_visible():
	owner.sprite.visible = not owner.sprite.visible
