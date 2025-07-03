class_name ProcedureGeneratoreLinearDungeon extends ProcedureGeneratorBase

@export var critical_path_length : int = 6
@export var debug : bool = true

const exits_names = ["UP", "RIGHT", "DOWN", "LEFT"]
var branch_canditates : Array[Room]


func _ready() -> void:
	self.generate_dungeon()
	if debug:
		print("CRITICAL_PATH:")
		super.print_dungeons()


func generate_dungeon() -> void:
	super.generate_dungeon()
	self.generate_paths(start, critical_path_length, ROOM_TYPES.CRITICAL)


func includes_dungeon_coords(coords: Vector2i, direction: Vector2i) -> bool:
	return (
		super.includes_x_in_dungeon(coords.x, direction.x) and 
		super.includes_y_in_dungeon(coords.y, direction.y)
	)


func is_critical_path_connect_itself(current_room : Room, variant_direction : Vector2i) -> bool:
	var new_position = current_room.coords + variant_direction
	var count_connection = 0

	var directions: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]

	for direction in directions:
		var coords : Vector2i = new_position + direction
		if not self.includes_dungeon_coords(coords, direction):
			continue
		if not dungeon[coords.x][coords.y]:
			continue
		if str(dungeon[coords.x ][coords.y].type_room) in [
				ROOM_TYPES.CRITICAL, 
				ROOM_TYPES.START
			]:
			count_connection += 1
	return count_connection > 1


func generate_paths(from_room : Room, length : int, marker : String) -> bool:
	if length == 0:
		return true
	var current_room : Room = from_room
	for exit in self.exits_names:
		var current_exit = current_room.exits_test[exit]
		if current_exit == Vector2i(-1, -1) or current_exit == null:
			continue
		if self.is_valid_critical_path(current_room, current_exit):
			var new_room = self.get_new_roow_with_marker_and_coords(marker, current_room.coords, current_exit)
			if length > 1:
				self.branch_canditates.append(new_room)
			if self.generate_paths(new_room, length - 1, marker):
				return true
			else:
				self.branch_canditates.erase(new_room)
				dungeon[new_room.coords.x][new_room.coords.y] = 0
	return false


func is_valid_critical_path(current_room: Room, direction: Vector2i) -> bool:
	var is_empty_room = dungeon[current_room.coords.x + direction.x][current_room.coords.y + direction.y]
	return not is_empty_room


func close_exits_in_empty_room() -> void:
	for x in self.dimensions.x:
		for y in self.dimensions.y:
			var room = dungeon[x][y]
			if not (room is Room):
				continue 
			var count_neighboring_rooms = get_count_neighboring_rooms(room)
			room.count_exits = count_neighboring_rooms


func get_count_neighboring_rooms(room : Room) -> int:
	var count_neighboring_rooms = 0
	for exit in self.exits_names:
		var current_exit = room.exits_test[exit]
		if current_exit == null:
			continue
		var new_coords = room.coords + current_exit
		if dungeon[new_coords.x][new_coords.y] is Room:
			count_neighboring_rooms += 1
		else:
			room.exits_test[exit] = null
	return count_neighboring_rooms


func get_new_roow_with_marker_and_coords(
		marker : String, 
		current_coords : Vector2i, 
		direction : Vector2i
	) -> Room:
	var new_coords = current_coords + direction
	var new_room = super.create_room(marker)
	new_room.coords = new_coords
	dungeon[new_room.coords.x][new_room.coords.y] = new_room
	new_room.define_init_exit(-direction)
	new_room.define_exits_for_room()
	return new_room


func generate_random_direction() -> Vector2i:
	match randi_range(0, 2):
		0:
			return Vector2i.UP
		1:
			return Vector2i.RIGHT
		2:
			return Vector2i.DOWN
	return Vector2i.LEFT
