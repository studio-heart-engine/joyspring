extends CanvasLayer

var HALF_WINDOW_SIZE = 0.5 * Vector2(320, 180)
onready var camera = $"../Camera"
onready var anim_player = $AnimationPlayer

func _ready():
	Events.connect("player_died", self, "on_player_died")

func on_player_died(position):
	offset = get_parent().position - camera.get_camera_screen_center() + HALF_WINDOW_SIZE
	anim_player.play("shrink-circle")
	yield(anim_player, "animation_finished")
	get_parent().respawn()
	yield(get_tree().create_timer(0.1), "timeout")
	offset = get_parent().position - camera.get_camera_screen_center() + HALF_WINDOW_SIZE
	anim_player.play_backwards("shrink-circle")