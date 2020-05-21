extends StaticBody2D

onready var anim_player = $AnimationPlayer

func _on_Area2D_area_entered(area):
	anim_player.play("wiggle")
	yield(anim_player, "animation_finished")
	anim_player.play(["rock1", "rock2"][randi() % 2])
	anim_player.get_animation(anim_player.current_animation).set_loop(false)
	yield(anim_player, "animation_finished")
	queue_free()

