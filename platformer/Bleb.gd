extends KinematicBody2D

export var GRAVITY = 12
export var SPEED = 10

onready var left_raycast = $Center/LeftRayCast
onready var right_raycast = $Center/RightRayCast

var velocity = Vector2(SPEED * [-1, 1][randi() % 2], 0)

func _ready():
	$Sprite.flip_h = velocity.x > 0

func _physics_process(delta):
	print(velocity)
	if is_on_wall():
		velocity.x *= -1
		$Sprite.flip_h = velocity.x > 0
		print("switch")
	velocity.y += GRAVITY
	move_and_slide(velocity, Vector2.UP)
