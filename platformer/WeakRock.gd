extends StaticBody2D

onready var anim_player = $AnimationPlayer
export (BitMap) var BITMASK

func _on_Area2D_area_entered(area):
	$TopArea/CollisionShape2D.set_deferred("disabled", true)
	anim_player.play("wiggle")
	yield(anim_player, "animation_finished")
	anim_player.play(["rock1", "rock2"][randi() % 2])
	$"weak-rock-outline".set_visible(true)
	anim_player.get_animation(anim_player.current_animation).set_loop(false)
	yield(anim_player, "animation_finished")
	$CollisionShape2D.set_deferred("disabled", true)

