extends StaticBody2D

onready var anim_player = $AnimationPlayer
onready var anim_player2 = $AnimationPlayer2

func _on_Area2D_area_entered(area):
	$TopArea/CollisionShape2D.set_deferred("disabled", true)
	anim_player.play("wiggle")
	yield(anim_player, "animation_finished")
	anim_player.play(["rock1", "rock2"][randi() % 2])
	anim_player2.play("shrink-hitbox")
	$"weak-rock-outline".set_visible(true)
	anim_player.get_animation(anim_player.current_animation).set_loop(false)
	yield(anim_player, "animation_finished")
	$Sprite.set_visible(false)
	yield(anim_player2, "animation_finished")
	$CollisionShape2D.set_deferred("disabled", true)

