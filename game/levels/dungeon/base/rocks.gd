extends TileMapLayer

const SOURCE_ID_ROCKS = 0
const ATLAST_ROCKS_COORDS_Y = 1
const COUNT_ROCKS_TILES = 2

const ROCKS_TILES_COORDS_X = {
	1: 8,
	2: 9,
}


func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for cell_position in get_used_cells():
		var random_index_rock = rng.randi_range(1, COUNT_ROCKS_TILES)
		var rock_x = ROCKS_TILES_COORDS_X[random_index_rock]
		var random_number = rng.randi_range(1, 4)
		if random_number == 1:
			set_cell(cell_position, SOURCE_ID_ROCKS, Vector2i(rock_x, ATLAST_ROCKS_COORDS_Y))
		else:
			erase_cell(cell_position)
