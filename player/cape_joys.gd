extends Node2D

enum MovementType {FLOATING, NOT_FLOATING}

export (int) var initial_cape_size = 10
export (int) var cape_size = initial_cape_size

export (Vector2) var cape_start_offset = Vector2(0, -7)

onready var Joy = preload("res://platformer/Joy.tscn")
onready var player = $"../.."
onready var anim_player = $"../AnimationPlayer"

var time_elapsed = 0
var noise = OpenSimplexNoise.new()
var movement_type = MovementType.NOT_FLOATING


func _ready():
	noise.octaves = 1
	
	set_process(false)
	for i in range(initial_cape_size):
		var joy = Joy.instance()
		add_child(joy)
		joy.set_following_player(true)
		joy.position = player.position
		joy.set_on_cape(true)
#		joy.is_on_cape = true
	set_process(true)
	
	Events.connect("float_started", self, "_on_float_started")
	Events.connect("float_ended", self, "_on_float_ended")


func _on_float_started():
	movement_type = MovementType.FLOATING

func _on_float_ended():
	movement_type = MovementType.NOT_FLOATING
	if anim_player.is_playing():
		anim_player.play_backwards()


func _process(delta):
	
	position = -player.position
	
	match movement_type:
		MovementType.FLOATING:
			var horizontal_noise_offset =  noise.get_noise_2d(100 * time_elapsed, 0)
			var vertical_noise_offset =  noise.get_noise_2d(0, 100 * time_elapsed)
			
			# offset all joys on cape
			for child in get_children():
				if child.is_on_cape:
					child.position += 1.8 * Vector2(horizontal_noise_offset, vertical_noise_offset)
		
		MovementType.NOT_FLOATING:
			var horizontal_noise_offset =  noise.get_noise_2d(100 * time_elapsed, 0)
			var vertical_noise_offset =  noise.get_noise_2d(0, 100 * time_elapsed)
			
			# offset all joys on cape
			for child in get_children():
				if child.is_on_cape:
					child.position += Vector2(
						0.7 * horizontal_noise_offset, vertical_noise_offset + 0.5)
	
	# follow first joy
	if get_child_count() > 0:
		get_child(0).follow(player.position + cape_start_offset, 0, 2, 1)
	for i in range(1, get_child_count()):
		get_child(i).follow(get_child(i-1).position, 0.5, 3, 0.7)
	
	time_elapsed += delta
