tool

extends Node2D

export (Texture) var texture

func _ready():
	$NoiseOffset/Outline.texture = texture
	$NoiseOffset/Sprite.texture = texture