extends TileMapLayer

const SOURCE_ID_BUSHES = 0
const ATLAS_BUSHES_COORDS_Y = 1
const COUNT_BUSHES_TILES = 4

const BUSHES_TILES_COORDS_X = {
	1: 4,
	2: 5,
	3: 6,
	4: 7,
}

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for cell_position in get_used_cells():
		var random_index_bushes = rng.randi_range(1, COUNT_BUSHES_TILES)
		var bush_x = BUSHES_TILES_COORDS_X[random_index_bushes]
		var random_number = rng.randi_range(1, 4)
		if random_number == 1:
			set_cell(cell_position, SOURCE_ID_BUSHES, Vector2i(bush_x, ATLAS_BUSHES_COORDS_Y))
		else:
			erase_cell(cell_position)
  
