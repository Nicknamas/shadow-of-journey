class_name ProcedureGeneratoreLinearDungeon extends ProcedureGeneratorBase

@export var critical_path_length : int = 6
@export var debug : bool = true

var count_rooms : int
var branch_canditates : Array[Room]


func _ready() -> void:
	self.generate_dungeon()
	if debug:
		print("CRITICAL_PATH:")
		super.print_dungeons()


func generate_dungeon() -> void:
	super.generate_dungeon()
	self.generate_paths(start, critical_path_length, ROOM_TYPES.CRITICAL)


func generate_critical_path() -> void:
	generate_paths(start, critical_path_length, ROOM_TYPES.CRITICAL)


func is_includes_coords_in_dungeon(coords: Vector2i, direction: Vector2i) -> bool:
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
		if not self.is_includes_coords_in_dungeon(coords, direction):
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
	var direction : Vector2i = self.generate_random_direction()
	count_rooms += 1
	for i in 4:
		if self.is_valid_critical_path(current_room, direction):
			var new_room = self.get_new_roow_with_marker_and_coords(marker, current_room.coords, direction)
			if length > 1:
				self.branch_canditates.append(new_room)
			if self.generate_paths(new_room, length - 1, marker):
				return true
			else:
				self.branch_canditates.erase(new_room)
				dungeon[new_room.coords.x][new_room.coords.y] = 0
		direction = Vector2(direction.y, -direction.x)
	count_rooms -= 1
	return false


func is_valid_critical_path(current_room: Room, direction: Vector2i) -> bool:
	if not self.is_includes_coords_in_dungeon(current_room.coords, direction):
		return false

	var not_itself_connection_room = not self.is_critical_path_connect_itself(current_room, direction)
	var is_empty_room = dungeon[current_room.coords.x + direction.x][current_room.coords.y + direction.y]
	return not_itself_connection_room and not is_empty_room


func get_new_roow_with_marker_and_coords(
		marker : String, 
		current_coords : Vector2i, 
		direction : Vector2i
	) -> Room:
	var new_coords = current_coords + direction
	var new_room = super.create_room(marker, -direction)
	new_room.coords = new_coords
	dungeon[new_room.coords.x][new_room.coords.y] = new_room
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
