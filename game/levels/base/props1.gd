extends TileMapLayer

const SOURCE_ID_PROPS = 1

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for cell_position in get_used_cells():
		var random_y = rng.randi_range(0, 1)
		var random_x = rng.randi_range(0, 15)
		set_cell(cell_position, SOURCE_ID_PROPS, Vector2i(random_x, random_y))
