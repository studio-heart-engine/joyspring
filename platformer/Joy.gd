extends Node2D

var POINTS_PER_COIN = 10
var is_following_player = false setget set_following_player
var is_on_cape = false setget set_on_cape

onready var anim_player = $AnimationPlayer


func _ready():
	rotation_degrees = randi() % 4 * 90
	anim_player.get_animation("collect1").set_loop(false)
	anim_player.advance(rand_range(0, anim_player.get_animation(anim_player.current_animation).length))


func set_following_player(value):
	is_following_player = value
	if value:
		anim_player.stop(false)
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$Particles.emitting = true


func set_on_cape(value):
	is_on_cape = value
	if value:
		$Particles.emitting = false


func _on_Hitbox_area_entered(area):
	
	PlayerData.score += POINTS_PER_COIN
	$Hitbox.set_deferred("monitoring", false)
	Events.emit_signal("joy_collected")
	get_parent().call_deferred("remove_child", self)
	$"../../Player/Cape/Joys".call_deferred("add_child", self)
	$"../../Player/Cape/Joys".cape_size += 1
	set_following_player(true)


func follow(target_pos, min_dist, max_dist, speed):
	if not is_on_cape: speed /= 3
	var diff = target_pos - position
	var dir = diff.normalized()
	var mag = diff.length()
	position += speed * min(mag - min_dist, 10) * dir
	diff = target_pos - position
	mag = diff.length()
	
	if mag <= max_dist and not is_on_cape:
		self.is_on_cape = true
		Events.emit_signal("joy_attached_to_cape")
	
	if mag > max_dist and is_on_cape:
		position += (mag - max_dist) * dir