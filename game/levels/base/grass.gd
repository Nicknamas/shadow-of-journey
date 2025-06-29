extends TileMapLayer

const SOURCE_ID_GRASS = 0
const ATLAST_GRASS_COORDS_Y = 1
const COUNT_GRASS_TILES = 3

const GRASS_TILES_COORDS_X = {
	1: 0,
	2: 2,
	3: 3
}

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for cell_position in get_used_cells():
		var random_index_grass = rng.randi_range(1, COUNT_GRASS_TILES)
		var grass_x = GRASS_TILES_COORDS_X[random_index_grass]
		var random_number = rng.randi_range(1, 2)
		if random_number == 1:
			set_cell(cell_position, SOURCE_ID_GRASS, Vector2i(grass_x, ATLAST_GRASS_COORDS_Y))
		else:
			erase_cell(cell_position)
  
