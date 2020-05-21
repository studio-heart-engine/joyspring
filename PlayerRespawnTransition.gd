extends CanvasLayer

var HALF_WINDOW_SIZE = 0.5 * Vector2(320, 180)
onready var camera = $"../Camera"
onready var anim_player = $AnimationPlayer

func _on_Player_ready():
	Events.connect("player_died", self, "on_player_died")
	
	offset = get_parent().position - camera.get_camera_screen_center() + HALF_WINDOW_SIZE
	anim_player.play_backwards("shrink-circle")

func on_player_died(position):
	offset = get_parent().position - camera.get_camera_screen_center() + HALF_WINDOW_SIZE
	anim_player.play("shrink-circle")
	yield(anim_player, "animation_finished")
	get_tree().reload_current_scene()
