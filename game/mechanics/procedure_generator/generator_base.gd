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
var instance_room : Room


func generate_dungeon() -> void:
	self.init_dungeons()
	self.place_start()


func init_dungeons() -> void:
	self.start = self.create_room(ROOM_TYPES.START)
	for x in dimensions.x:
		self.dungeon.append([])
		for y in dimensions.y:
			self.dungeon[x].append(0)


func place_start() -> void:
	if not includes_x_in_dungeon(self.start.coords.x, Vector2i.ZERO.x):
		self.start.coords.x = randi_range(0, self.dimensions.x - 1)
	if not includes_y_in_dungeon(self.start.coords.y, Vector2i.ZERO.y):
		self.start.coords.y = randi_range(0, self.dimensions.y - 1)
	self.dungeon[self.start.coords.x][self.start.coords.y] = self.start


func includes_x_in_dungeon(x : int, direction_x : int) -> bool:
	return x + direction_x >= 0 and x + direction_x < self.dimensions.x


func includes_y_in_dungeon(y : int, direction_y : int) -> bool:
	return y + direction_y >= 0 and y + direction_y < dimensions.y


func create_room(type_room : String, init_exit : Vector2i = Vector2i(-1, -1)) -> Room:
	return Room.new(type_room, init_exit)


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


func get_dungeon() -> Array:
	return self.dungeon
