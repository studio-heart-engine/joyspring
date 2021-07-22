tool
extends TileMap

func _ready():
	self.modulate = Color(0, 0, 0)
	self.material = self.material.duplicate()

	if self.get_parent().get_name() == 'Layer0':
		self.collision_layer = pow(2, 3)
		self.collision_mask = pow(2, 0) + pow(2, 1) + pow(2, 4)
		
		self.light_mask = pow(2, 0)
		self.occluder_light_mask = pow(2, 0)
	if self.get_parent().get_name() == 'Layer1':
		self.collision_layer = pow(2, 8)
		self.collision_mask = pow(2, 5) + pow(2, 6) + pow(2, 9)
		
		self.light_mask = pow(2, 5)
		self.occluder_light_mask = pow(2, 5)
