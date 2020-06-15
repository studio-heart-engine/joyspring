extends Node2D

export (int) var initial_cape_size = 15
export (Vector2) var cape_start_offset = Vector2(0, -7)

onready var Joy = preload("res://platformer/Joy.tscn")
onready var player = get_parent()

var time_elapsed = 0
var noise = OpenSimplexNoise.new()

func _ready():
	
	noise.octaves = 1
	
	set_process(false)
	for i in range(initial_cape_size):
		var joy = Joy.instance()
		add_child(joy)
		joy.set_following_player(true)
		joy.position = player.position
		joy.is_on_cape = true
	set_process(true)

func _process(delta):
	position = -player.position
	
	var n = get_child_count()
	
	var horizontal_noise_offset =  noise.get_noise_2d(150 * time_elapsed, 0)
	var vertical_noise_offset =  noise.get_noise_2d(0, 150 * time_elapsed)
	
	# move the last joy thats on the cape randomly centered around the middle joy
	var j = n-1
	while not get_child(j).is_on_cape and j > 0:
		j -= 1
	
	for i in range(j+1):
		get_child(i).position += Vector2(horizontal_noise_offset, vertical_noise_offset)
	
	# follow first joy after following the last one so the max_dist is correctly enforced
	
	get_child(0).follow(player.position + cape_start_offset, 0, 2, 1)
	for i in range(1, n):
		get_child(i).follow(get_child(i-1).position, 0.5, 3, 0.7)
	
	time_elapsed += delta
