tool
extends Node2D

# Tile ID:
# 0: Autotile
# 1: Dirt
# 2: Dirt props
# 3: Grass
# 4: Grass props
# 5: Pebbles
# 6: Pebble props
# 7: Rocks
# 8: Rock props
# 9: Stones
# 10: Stone props

func _ready():
	update_tileset()

func update_tileset():
	$AutoTileMap.show()
	for id in range(1, 11):
		for cell in $TextureTileMap.get_used_cells_by_id(id):
			var autotile_coord = $AutoTileMap.get_cell_autotile_coord(cell.x, cell.y)
			$TextureTileMap.set_cell(cell.x, cell.y, id, false, false, false, autotile_coord)
	$AutoTileMap.hide()
