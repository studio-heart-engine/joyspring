tool

extends Node2D

export (Texture) var texture

var possible_colors = [
	"#f82f68",
	"#f82fa2",
	"#e841cf"
]

func _ready():
	$NoiseOffset/Outline.texture = texture
	$NoiseOffset/Sprite.texture = texture
	$NoiseOffset/Outline.modulate = Color(possible_colors[randi() % possible_colors.size()])