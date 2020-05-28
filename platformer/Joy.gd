extends Node2D

var POINTS_PER_COIN = 10
var SLOW_MO_DURATION_SEC = 0.2
var SLOW_MO_TIME_SCALE = 0.2
var is_following_player = false
onready var anim_player = $AnimationPlayer
onready var player = $"../../Player"


func _on_Hitbox_area_entered(area):
	PlayerData.score += POINTS_PER_COIN
	$Hitbox.set_deferred("monitoring", false)
	Events.emit_signal("joy_collected")
	is_following_player = true
	player.joy_followers.append(self)


func _ready():
	anim_player.get_animation("collect1").set_loop(false)
	anim_player.advance(rand_range(0, anim_player.get_animation(anim_player.current_animation).length))


func _process(delta):
	if is_following_player:
		var i = player.joy_followers.find(self)
		if i == 0: follow(player.position + Vector2(0, -8), 13)
		else: follow(player.joy_followers[i-1].position, 8)


func follow(target_pos, radius):
	var diff = target_pos - self.position
	diff = (diff.length() - radius) * diff.normalized()
	self.position += 0.1 * diff