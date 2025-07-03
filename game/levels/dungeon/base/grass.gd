extends TileMapLayer

const SOURCE_ID_GRASS = 1
const ATLAST_GRASS_COORDS_Y = 1
const HEIGHT_GRASS_EXAMPLE_TILES = -19
const COUNT_GRASS_EXAMPLE_TILES = 64

var grass_atlas_tiles : Array[Vector2i] = []
var rng : RandomNumberGenerator


func _ready() -> void:
	self.init_randomizer()
	self.init_atlas_grass_tiles()
	for cell_position in get_used_cells():
		var random_index_grass : int = self.rng.randi_range(0, COUNT_GRASS_EXAMPLE_TILES - 1)
		var random_grass_tile : Vector2i = self.grass_atlas_tiles[random_index_grass]
		var random_number = rng.randi_range(1, 4)
		if random_number == 1:
			set_cell(cell_position, SOURCE_ID_GRASS, random_grass_tile)
		else:
			erase_cell(cell_position)
 

func init_randomizer() -> void:
	self.rng = RandomNumberGenerator.new()
	rng.randomize()


func init_atlas_grass_tiles() -> void:
	for i in range(self.COUNT_GRASS_EXAMPLE_TILES):
		var atlas_coord_tile = get_cell_atlas_coords(Vector2i(i, self.HEIGHT_GRASS_EXAMPLE_TILES))
		self.grass_atlas_tiles.append(atlas_coord_tile)
