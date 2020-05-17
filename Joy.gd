extends Node2D

var POINTS_PER_COIN = 10
var SLOW_MO_DURATION_SEC = 0.2
var SLOW_MO_TIME_SCALE = 0.2
onready var anim_player = $AnimationPlayer


func _ready():
	anim_player.get_animation("collect1").set_loop(false)
	anim_player.advance(rand_range(0, anim_player.get_animation(anim_player.current_animation).length))


func _on_Hitbox_area_entered(area):
	PlayerData.score += POINTS_PER_COIN
	$Hitbox.set_deferred("monitoring", false)
	Events.emit_signal("joy_collected")
	anim_player.play("collect1", -1, 2)
	yield(anim_player, "animation_finished")
	queue_free()
