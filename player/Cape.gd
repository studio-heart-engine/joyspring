extends Node2D

export (int) var initial_cape_size = 7
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
	
	var horizontal_noise_offset = 60 * noise.get_noise_2d(0, 60 * time_elapsed)
	
	# move the last joy thats on the cape
	var j = n-1
	while not get_child(j).is_on_cape:
		j -= 1
	get_child(j).position.x = get_child(j/2).position.x + horizontal_noise_offset
	j -= 1
	# everyone else follows
	while j >= 0:
		get_child(j).follow(get_child(j+1).position, 1, 3, 0.3)
		j -= 1
	
	# follow first joy after following the last one so the max_dist is correctly enforced B)
	var vertical_noise_offset = 8 * noise.get_noise_2d(0, 150 * time_elapsed) * Vector2.UP
	get_child(0).follow(player.position + cape_start_offset + vertical_noise_offset, 0, 2, 1)
	for i in range(1, n):
		get_child(i).follow(get_child(i-1).position, 1, 3, 0.75)
	
	time_elapsed += delta
