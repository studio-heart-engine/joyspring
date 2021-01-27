extends StaticBody2D

onready var anim_player = $AnimationPlayer
onready var anim_player2 = $AnimationPlayer2

func _ready():
	update_image()

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



enum TIME_OF_DAY {dawn, evening, midnight}

export (TIME_OF_DAY) var time_of_day = TIME_OF_DAY.evening setget set_time_of_day

func update_image():
	var image_path = "res://graphics/sprites/gravel" + get_time_of_day() + ".png"
	$Sprite.set_texture(load(image_path))

func get_time_of_day():
	return TIME_OF_DAY.keys()[time_of_day]

func set_time_of_day(value):
	time_of_day = value
	update_image()