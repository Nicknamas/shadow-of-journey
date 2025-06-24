class_name ProcedureGeneratorBase extends Node2D

@export var dimensions : Vector2i = Vector2(4, 4)
@export var start : Room
@export var room_scene : PackedScene

const ROOM_TYPES = {
	"START": "start",
	"CRITICAL": "critical",
	"START_BRANCH": "sb",
	"BRANCH": "branch"
}

var dungeon : Array
var init_room : Room


func generate_dungeon() -> void:
	await self.init_init_room()
	self.init_dungeons()
	self.place_start()


func init_init_room() -> void:
	self.init_room = self.room_scene.instantiate()
	await self.get_parent().ready
	self.get_parent().add_child(self.init_room)
	if !self.init_room.is_node_ready():
		await self.init_room.ready


func init_dungeons() -> void:
	self.start = create_room(ROOM_TYPES.START)
	for x in dimensions.x:
		self.dungeon.append([])
		for y in dimensions.y:
			self.dungeon[x].append(0)


func place_start() -> void:
	if not includes_x_in_dungeon(self.start.coords.x, Vector2i.ZERO.x):
		self.start.coords.x = randi_range(0, self.dimensions.x - 1)
	if not includes_y_in_dungeon(self.start.coords.y, Vector2i.ZERO.y):
		self.start.coords.y = randi_range(0, self.dimensions.y - 1)
	dungeon[self.start.coords.x][self.start.coords.y] = self.start


func includes_x_in_dungeon(x : int, direction_x : int) -> bool:
	return x + direction_x >= 0 and x + direction_x < self.dimensions.x


func includes_y_in_dungeon(y : int, direction_y : int) -> bool:
	return y + direction_y >= 0 and y + direction_y < dimensions.y


func get_hero() -> Node2D:
	return get_tree().get_first_node_in_group("Hero") as Node2D


func set_position_hero_to_start() -> void:
	var hero = self.get_hero()
	var coords_center_start = self.get_coords_center_start()
	hero.global_position = Vector2(coords_center_start.x, coords_center_start.y)


func get_coords_center_start() -> Vector2i:
	var signed_coords = self.get_processed_signed_coords()
	var center_x = self.start.coords.x * self.room_size + (self.room_size / 2)  * signed_coords.x
	var center_y = self.start.coords.y * self.room_size + (self.room_size / 2) * signed_coords.y
	return Vector2i(center_x, center_y)


func get_processed_signed_coords() -> Vector2i:
	var signed_coords = self.start.coords.sign()
	return self.process_signed_coords(signed_coords)


func process_signed_coords(coords: Vector2i) -> Vector2i:
	if coords.x == 0:
		coords.x = 1
	if coords.y == 0:
		coords.y = 1
	return coords


func create_room(type_room : String, init_exit : Vector2i = Vector2i(-1, -1)) -> Room:
	var room: Room = self.init_room.duplicate()
	room.set_values(type_room, init_exit)
	return room


func print_dungeons() -> void:
	var dungeon_as_string: String = ""
	for y in self.dimensions.y:
		for x in self.dimensions.x:
			if self.dungeon[x][y]:
				dungeon_as_string += "[" + self.dungeon[x][y].type_room[0] + self.dungeon[x][y].type_room[1] + "]"
			else:
				dungeon_as_string += "    "
		dungeon_as_string += "\n"
	print(dungeon_as_string)
