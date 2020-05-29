extends KinematicBody2D

export var GRAVITY = 12
export var SPEED = 10

enum states {CRAWL, TURN, FALL}

onready var anim_player = $AnimationPlayer

var facing_right = [true, false][randi() % 2]
var velocity = Vector2(SPEED if facing_right else -SPEED, 0)
var state = states.CRAWL


func _on_Hitbox_area_entered(area):
	Events.emit_signal("player_died", area.position)


func _ready():
	$Sprite.flip_h = facing_right
	anim_player.play("crawl")


func _physics_process(delta):
	match state:
		states.CRAWL:
			velocity = move_and_slide(velocity, Vector2.UP)
			if velocity.x == 0:
				state = states.TURN
				anim_player.play("turn")
			elif not is_on_floor():
				velocity.y = 0
				state = states.FALL
				anim_player.play("fall")
		states.FALL:
			velocity.y += GRAVITY
			velocity = move_and_slide(velocity, Vector2.UP)
			if velocity.y == 0:
				state = states.CRAWL
				anim_player.play("crawl")
		states.TURN:
			if not anim_player.is_playing():
				state = states.CRAWL
				facing_right = not facing_right
				$Sprite.flip_h = facing_right
				anim_player.play("crawl")
				velocity.x = SPEED if facing_right else -SPEED
