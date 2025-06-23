extends Node2D

@export var dimensions : Vector2i = Vector2(4, 4)
@export var start : Room
@export var critical_path_length : int = 6
@export var branches : int = 3
@export var branches_length : Vector2i = Vector2i(1, 3)
@export var room_scene : PackedScene
@export var room_script : Script


var room_instance : Room
var branch_canditates : Array[Room]
var dungeon : Array
var count_rooms : int
var tilemap_size : Vector2i
var room_size : int
const texture_size : int = 16

const ROOM_TYPES = {
	"START": "start",
	"CRITICAL": "critical",
	"START_BRANCH": "sb",
	"BRANCH": "branch"
}


func _ready() -> void:
	await self.generate_dungeon()
	self.render_dungeon()
	self.init_position_hero()


func init_position_hero() -> void:
	var hero = get_tree().get_first_node_in_group("Hero") as Node2D
	var signed_coords = self.start.coords.sign()
	if signed_coords.x == 0:
		signed_coords.x = 1
	if signed_coords.y == 0:
		signed_coords.y = 1
	hero.global_position = Vector2(
		self.start.coords.x * self.room_size + 112 * signed_coords.x, 
		self.start.coords.y * self.room_size + 112 * signed_coords.y
	)


func render_dungeon() -> void:
	for row in dungeon:
		for room in row:
			if room and room is Room:
				get_parent().add_child.call_deferred(room)
				var room_position_x = room.coords.x * self.room_size
				var room_position_y = room.coords.y * self.room_size
				room.global_position = Vector2(room_position_x, room_position_y)


func generate_dungeon() -> void:
	self.room_instance = self.room_scene.instantiate()
	await get_parent().ready
	get_parent().add_child(self.room_instance)
	if !self.room_instance.is_node_ready():
		await self.room_instance.ready
	self.tilemap_size = self.room_instance.size
	self.room_size = self.tilemap_size.x * self.texture_size
	clear_values()
	initializy_dungeons()
	place_entrace()
	generate_critical_path()
	generate_branches()
	print_dungeons()


func clear_values() -> void:
	self.dungeon.clear()
	self.branch_canditates.clear()
	self.start = create_room(ROOM_TYPES.START)


func initializy_dungeons() -> void:
	for x in dimensions.x:
		dungeon.append([])
		for y in dimensions.y:
			dungeon[x].append(0)


func place_entrace() -> void:
	if start.coords.x < 0 or start.coords.x > dimensions.x:
		start.coords.x = randi_range(0, dimensions.x - 1)
	if start.coords.y < 0 or start.coords.y > dimensions.y:
		start.coords.y = randi_range(0, dimensions.y - 1)
	dungeon[start.coords.x][start.coords.y] = start


func create_room(type_room : String, init_exit : Vector2i = Vector2i(-1, -1)) -> Room:
	var room: Room = self.room_instance.duplicate()
	room.set_values(type_room, init_exit)
	return room


func generate_critical_path() -> void:
	generate_path(start, critical_path_length, ROOM_TYPES.CRITICAL)


func is_includes_coords_in_dungeon(room: Room, direction: Vector2i) -> bool:
	var includes_x_in_dungeon: bool = room.coords.x + direction.x >= 0 and room.coords.x + direction.x < dimensions.x
	var includes_y_in_dungeon: bool = room.coords.y + direction.y >= 0 and room.coords.y + direction.y < dimensions.y
	return includes_x_in_dungeon and includes_y_in_dungeon


func is_critical_path_connect_itself(current_room : Room, direction : Vector2i) -> bool:
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


func generate_path(from_room : Room, length : int, marker : String) -> bool:
	if length == 0:
		return true
	var current_room : Room = from_room
	var direction : Vector2i = generate_random_direction()
	count_rooms += 1
	
	for i in 4:
		if (
			is_includes_coords_in_dungeon(current_room, direction) and 
			not is_critical_path_connect_itself(current_room, direction) and
			not dungeon[current_room.coords.x + direction.x][current_room.coords.y + direction.y] 
		):
			var new_coords = current_room.coords + direction
			var new_room = create_room(marker, -direction)
			new_room.coords = new_coords
			dungeon[new_room.coords.x][new_room.coords.y] = new_room
			if marker == ROOM_TYPES.START_BRANCH:
				marker = ROOM_TYPES.BRANCH
			if length > 1:
				branch_canditates.append(new_room)
			if generate_path(new_room, length - 1, marker):
				return true
			else:
				branch_canditates.erase(new_room)
				dungeon[new_room.coords.x][new_room.coords.y] = 0
		direction = Vector2(direction.y, -direction.x)
	count_rooms -= 1
	return false


func generate_random_direction() -> Vector2i:
	match randi_range(0, 2):
		0:
			return Vector2i.UP
		1:
			return Vector2i.RIGHT
		2:
			return Vector2i.DOWN
	return Vector2i.LEFT


func generate_branches() -> void:
	var branches_created : int = 0
	var candidate : Room
	while branches_created < branches and branch_canditates.size():
		candidate = branch_canditates[randi_range(0, branch_canditates.size() - 1)]
		if generate_path(candidate, randi_range(branches_length.x, branches_length.y), ROOM_TYPES.START_BRANCH):
			branches_created += 1
		else:
			branch_canditates.erase(candidate)


func print_dungeons() -> void:
	var dungeon_as_string: String = ""
	for y in dimensions.y:
		for x in dimensions.x:
			if dungeon[x][y]:
				dungeon_as_string += "[" + dungeon[x][y].type_room[0] + dungeon[x][y].type_room[1] + "]"
			else:
				dungeon_as_string += "    "
		dungeon_as_string += "\n"
	print(dungeon_as_string)
