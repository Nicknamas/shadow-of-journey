extends TileMapLayer

const SOURCE_ID_BUSHES = 0
const ATLAS_BUSHES_COORDS_Y = 1

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for cell_position in get_used_cells():
		var random_number = rng.randi_range(1, 5)
		if random_number == 1:
			set_cell(cell_position, SOURCE_ID_BUSHES, Vector2i(7, ATLAS_BUSHES_COORDS_Y))
		else:
			erase_cell(cell_position)
  
