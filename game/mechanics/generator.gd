extends Node2D

@export var _dimensions : Vector2i = Vector2(7, 5)
@export var _start_room : Room = _create_room("Start")
@export var _critical_path_length : int = 6
@export var _branches : int = 3
@export var _branches_length : Vector2i = Vector2i(1, 3)

var scene = preload("res://game/levels/room.tscn")
var instance : Node 
var _branch_canditates : Array[Room]
var dungeon : Array
var count_rooms : int

const ROOM_TYPES = {
	"START": "start",
	"CRITICAL": "critical",
	"START_BRANCH": "start-branch",
	"BRANCH": "branch"
}


#func _process(delta):
	#if Input.is_action_pressed("left"):
		#print(get_children()[5])


func _ready():
	_generate_dungeon()
	#instance = scene.instantiate()
	#create_dungeon()

func create_dungeon():
	for i in count_rooms:
		add_child(instance.duplicate())
	for child in get_children():
		if child.name == "Room":
			child.set_script(load("res://game/levels/room.gd"))


func _generate_dungeon(): 
	_clear_values()
	_initializy_dungeons()
	_place_entrace()
	_generate_critical_path()
	_generate_branches()
	print(count_rooms)
	_print_dungeons()


func _clear_values() -> void:
	dungeon.clear()
	_branch_canditates.clear()
	_start_room = _create_room(ROOM_TYPES.START)


func _initializy_dungeons() -> void:
	for x in _dimensions.x:
		dungeon.append([])
		for y in _dimensions.y:
			dungeon[x].append(0)


func _place_entrace() -> void:
	if _start_room.coords.x < 0 or _start_room.coords.x > _dimensions.x:
		_start_room.coords.x = randi_range(0, _dimensions.x - 1)
	if _start_room.coords.y < 0 or _start_room.coords.y > _dimensions.y:
		_start_room.coords.y = randi_range(0, _dimensions.y - 1)


func _create_room(type_room : String, init_exit : Vector2i = Vector2i(-1, -1)) -> Room:
	return Room.new(type_room, init_exit)


func _generate_critical_path() -> void:
	_generate_path(_start_room, _critical_path_length, ROOM_TYPES.START)


func _is_includes_coords_in_dungeon(room: Room, direction: Vector2i) -> bool:
	var includes_x_in_dungeon: bool = room.coords.x + direction.x >= 0 and room.coords.x + direction.x < _dimensions.x
	var includes_y_in_dungeon: bool = room.coords.y + direction.y >= 0 and room.coords.y + direction.y < _dimensions.y
	return includes_x_in_dungeon and includes_y_in_dungeon


func _is_critical_path_connect_itself(current_room : Room, direction : Vector2i) -> bool:
	if current_room.type_room != ROOM_TYPES.CRITICAL:
		return false

	var new_position = current_room.coords + direction
	var count_connection = 0

	var directions: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]

	for element in directions:
		var coords : Vector2i = new_position + element
		if coords.x >= dungeon.size():
			continue
		if coords.y >= dungeon[coords.x].size():
			continue
		if str(dungeon[coords.x][coords.y]) in [ROOM_TYPES.CRITICAL, ROOM_TYPES.START, ROOM_TYPES.START_BRANCH]:
			count_connection += 1
	return count_connection > 1


func _generate_path(from_room : Room, length : int, marker : String) -> bool:
	if length == 0:
		return true
	var current_room : Room = from_room
	var direction : Vector2i = _generate_random_direction()
	count_rooms += 1
	
	for i in 4:
		if (
			_is_includes_coords_in_dungeon(current_room, direction) and 
			not _is_critical_path_connect_itself(current_room, direction) and
			not dungeon[current_room.coords.x + direction.x][current_room.coords.y + direction.y] 
		):
			var new_coords = current_room.coords + direction
			var new_room = _create_room(marker, -direction)
			new_room.coords = new_coords
			dungeon[new_room.coords.x][new_room.coords.y] = new_room
			if marker == ROOM_TYPES.START:
				marker = ROOM_TYPES.CRITICAL
			if marker == ROOM_TYPES.START_BRANCH:
				marker = ROOM_TYPES.BRANCH
			if length > 1:
				_branch_canditates.append(new_room)
			if _generate_path(new_room, length - 1, marker):
				return true
			else:
				_branch_canditates.erase(new_room)
				dungeon[new_room.coords.x][new_room.coords.y] = 0
		direction = Vector2(direction.y, -direction.x)
	count_rooms -= 1
	return false


func _generate_random_direction() -> Vector2i:
	match randi_range(0, 2):
		0:
			return Vector2i.UP
		1:
			return Vector2i.RIGHT
		2:
			return Vector2i.DOWN
	return Vector2i.LEFT


func _generate_branches() -> void:
	var branches_created : int = 0
	var candidate : Room
	while branches_created < _branches and _branch_canditates.size():
		candidate = _branch_canditates[randi_range(0, _branch_canditates.size() - 1)]
		if _generate_path(candidate, randi_range(_branches_length.x, _branches_length.y), ROOM_TYPES.START_BRANCH):
			branches_created += 1
		else:
			_branch_canditates.erase(candidate)


func _print_dungeons() -> void:
	var dungeon_as_string: String = ""
	for y in range(_dimensions.y - 1, -1, -1):
		for x in _dimensions.x:
			if dungeon[x][y]:
				dungeon_as_string += "[" + dungeon[x][y].type_room[0] + "]"
			else:
				dungeon_as_string += "   "
		dungeon_as_string += "\n"
	print(dungeon_as_string)
