class_name Walls extends RoomElement

const EXIT_NAMES = ["UP", "RIGHT", "DOWN", "LEFT"]

const COORDS_BLOCKS = {
	"UP": Vector2i(3, -7),
	"RIGHT": Vector2i(37, -7),
	"DOWN": Vector2i(2, 21),
	"LEFT": Vector2i(0, -7)
}

const INDEXES_PATTERN = {
	"UP_OPEN": 0,
	"RIGHT_OPEN": 2,
	"DOWN_OPEN": 6,
	"LEFT_OPEN": 1,
	"UP_CLOSE": 5,
	"RIGHT_CLOSE": 3,
	"DOWN_CLOSE": 7,
	"LEFT_CLOSE": 4
}


func define(exits: Dictionary) -> void:
	for exit in EXIT_NAMES:
		var coords = COORDS_BLOCKS[exit]
		var pattern : TileMapPattern
		var exit_state : String

		if exits[exit]:
			exit_state = exit + "_OPEN"
		else:
			exit_state = exit + "_CLOSE"

		pattern = tile_set.get_pattern(INDEXES_PATTERN[exit_state])
		set_pattern(coords, pattern)
