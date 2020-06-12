extends Node2D

export (int) var initial_cape_size = 7

onready var CapeBlob = preload("res://player/CapeBlob.tscn")
onready var player = get_parent()

var time_elapsed = 0

func _ready():
	for i in range(initial_cape_size):
		add_child(CapeBlob.instance())

func _process(delta):
	position = -player.position
	get_child(0).follow(player.position + (7 + sin(time_elapsed * 7)) * Vector2.UP, 0, 2, 1)
	for i in range(1, get_child_count()):
		get_child(i).follow(get_child(i-1).position, 1, 2, 0.3)
	
	time_elapsed += delta
