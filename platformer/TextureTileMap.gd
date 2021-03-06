tool
extends TileMap

enum TILE_MATERIAL {dirt, grass, pebbles, rocks, stones}

var TIME_OF_DAY = ['evening', 'midnight', 'dawn']

func get_time_of_day():
	return TIME_OF_DAY[globals.time_of_day]

var dynamic_tileset = load("res://graphics/tilesets/foreground_tileset_image.tres")
var dynamic_material_tilesets = []

func _ready():
	self.material = self.material.duplicate()
	for material in TILE_MATERIAL:
		dynamic_material_tilesets.append(
			"res://graphics/tilesets/foreground_" + material + "_tileset_image.tres"
		)
	update_tileset()
	Events.connect('time_of_day_changed', self, 'update_tileset')
	
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
	
	self.show()

func update_tileset():
	for i in len(TILE_MATERIAL):
		var tileset_image_path =  "res://graphics/tilesets/" + get_time_of_day() + "/" + TILE_MATERIAL.keys()[i] + ".png"
		load(dynamic_material_tilesets[i]).image = load(tileset_image_path)
	
	var auto_tile = get_node('../TileMap')
	auto_tile.show()
	for id in range(1, 11):
		for cell in self.get_used_cells_by_id(id):
			var autotile_coord = auto_tile.get_cell_autotile_coord(cell.x, cell.y)
			self.set_cell(cell.x, cell.y, id, false, false, false, autotile_coord)
	auto_tile.hide()
