extends Node2D

export (int) var scarf_size = 5

var ScarfBlob = preload("res://player/ScarfBlob.tscn")
onready var player = get_parent()

var scarf_blobs

func _ready():
	for i in range(scarf_size):
		add_child(ScarfBlob.instance())

func _process(delta):
	position = -player.position
	get_child(0).follow(player.position + 7 * Vector2.UP, 0, 1)
	for i in range(1, scarf_size):
		get_child(i).follow(get_child(i-1).position, 1, 0.7)
