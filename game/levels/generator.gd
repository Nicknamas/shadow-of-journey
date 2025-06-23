extends Node2D

@export var _dimensions : Vector2i = Vector2(7, 5)
@export var _start : Vector2i = Vector2i(-1, -1)
@export var _critical_path_length : int = 9
@export var _branches : int = 3
@export var _branches_length : Vector2i = Vector2i(1, 4)

var _branch_canditates : Array[Vector2i]
var dungeon: Array

func _process(delta):
	if Input.is_action_pressed("left"):
		_create_dungeon()


func _ready():
	_create_dungeon()


func _create_dungeon():
	_clear_values()
	_initializy_dungeons()
	_place_entrace()
	_generate_critical_path()
	_generate_branches()
	_print_dungeons()
	

func _clear_values() -> void:
	dungeon.clear()
	_branch_canditates.clear()
	_start = Vector2i(-1, -1)


func _initializy_dungeons() -> void:
	for x in _dimensions.x:
		dungeon.append([])
		for y in _dimensions.y:
			dungeon[x].append(0)


func _place_entrace() -> void:
	if _start.x < 0 or _start.x > _dimensions.x:
		_start.x = randi_range(0, _dimensions.x - 1)
	if _start.y < 0 or _start.y > _dimensions.y:
		_start.y = randi_range(0, _dimensions.y - 1)
	dungeon[_start.x][_start.y] = "S"


func _generate_critical_path() -> void:
	_generate_path(_start, _critical_path_length, "c")


func _is_includes_coords_in_dungeon(coords: Vector2i, direction: Vector2i) -> bool:
	var includes_x_in_dungeon: bool = coords.x + direction.x >= 0 and coords.x + direction.x < _dimensions.x
	var includes_y_in_dungeon: bool = coords.y + direction.y >= 0 and coords.y + direction.y < _dimensions.y
	return includes_x_in_dungeon and includes_y_in_dungeon


func _generate_path(from : Vector2i, length : int, marker : String) -> bool:
	if length == 0:
		return true
	var current : Vector2i = from
	var direction : Vector2i
	match randi_range(0, 3):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.RIGHT
		2:
			direction = Vector2i.DOWN
		3:
			direction = Vector2i.LEFT
	for i in 4:
		if (
			_is_includes_coords_in_dungeon(current, direction) and not dungeon[current.x + direction.x][current.y + direction.y]
		):
			current += direction
			dungeon[current.x][current.y] = marker
			if length > 1:
				_branch_canditates.append(current)
			if _generate_path(current, length - 1, marker):
				return true
			else:
				_branch_canditates.erase(current)
				dungeon[current.x][current.y] = 0
				current -= direction
		direction = Vector2(direction.y, -direction.x)
	return false


func _generate_branches() -> void:
	var branches_created : int = 0
	var candidate : Vector2i
	while branches_created < _branches and _branch_canditates.size():
		candidate = _branch_canditates[randi_range(0, _branch_canditates.size() - 1)]
		if _generate_path(candidate, randi_range(_branches_length.x, _branches_length.y), "b"):
			branches_created += 1
		else:
			_branch_canditates.erase(candidate)


func _print_dungeons() -> void:
	var dungeon_as_string: String = ""
	for y in range(_dimensions.y - 1, -1, -1):
		for x in _dimensions.x:
			if dungeon[x][y]:
				dungeon_as_string += "[" + str(dungeon[x][y]) + "]"
			else:
				dungeon_as_string += "   "
		dungeon_as_string += "\n"
	print(dungeon_as_string)
