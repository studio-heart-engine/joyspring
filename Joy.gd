extends Node2D

var POINTS_PER_COIN = 10
onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.get_animation("collect1").set_loop(false)


func _on_Hitbox_area_entered(area):
	PlayerData.score += POINTS_PER_COIN
	Events.emit_signal("coin_collected")
	anim_player.play("collect1", -1, 2)
	yield(anim_player, "animation_finished")
	queue_free()
