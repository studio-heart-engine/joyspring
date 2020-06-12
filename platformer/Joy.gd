extends Node2D

var POINTS_PER_COIN = 10
var SLOW_MO_DURATION_SEC = 0.2
var SLOW_MO_TIME_SCALE = 0.2
var is_following_player = false
onready var anim_player = $AnimationPlayer
onready var cape = $"../../Player/Cape"


func _on_Hitbox_area_entered(area):
	PlayerData.score += POINTS_PER_COIN
	$Hitbox.set_deferred("monitoring", false)
	Events.emit_signal("joy_collected")
	


func _ready():
	anim_player.get_animation("collect1").set_loop(false)
	anim_player.advance(rand_range(0, anim_player.get_animation(anim_player.current_animation).length))