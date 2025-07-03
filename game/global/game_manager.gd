class_name GameManager extends Node

const PATH_TO_LEVEL = "/root/World/Level"
const NAME_NODE_DOORS = "Doors"
const exits_name = ["UP", "RIGHT", "DOWN", "LEFT"]

const DIRECTION_OF_3EXIT_ROOM = {
	"UP": "1",
	"RIGHT": "2",
	"DOWN": "3",
	"LEFT": "4",
}

const DIRECTION_OF_2EXIT_ROOM = {
	"UP": {
		"UP": null,
		"RIGHT": "3",
		"DOWN": "1",
		"LEFT": "6",
	},
	"RIGHT": {
		"DOWN": "4",
		"LEFT": "2",
	},
	"DOWN": {
		"LEFT": "5",
	},
}

const DIRECTION_OF_1EXIT_ROOM = {
	"UP": "1",
	"RIGHT": "2",
	"DOWN": "3",
	"LEFT": "4",
}

var procedure_generator : ProcedureGeneratorBranchesDungeon
var dungeon : Array
var current_room : Room

func _ready():
	NavigationManager.on_navigate.connect(_on_navigate)
	self.procedure_generator = await ProcedureGeneratorBranchesDungeon.new()
	self.dungeon = self.procedure_generator.get_dungeon()
	self.procedure_generator.close_exits_in_empty_room()
	self.current_room = self.procedure_generator.start
	self.init_exits_of_current_room()


func init_exits_of_current_room() -> void:
	var level = get_node(PATH_TO_LEVEL)
	var room = level.get_child(0)
	var doors = room.get_node(NAME_NODE_DOORS) as Node
	
	for exit in self.exits_name:
		var current_exit = current_room.exits_test[exit]
		if not current_exit:
			continue

		var new_coords = current_exit + current_room.coords
		var cell = self.dungeon[new_coords.x][new_coords.y]
		var door = get_door_with_position(exit, doors) as Node
		if cell is Room:
			door.destination_level_tag = get_level_tag(cell)
		else:
			door.queue_free()
			doors.remove_child(door)


func get_door_with_position(position : String, doors):
	for door in doors.get_children():
		if door.position_door == position:
			return door


func get_level_tag(cell) -> String:
	if not cell is Room:
		return ""
	
	match cell.count_exits:
		4:
			return get_level_tag_4exit(cell)
		3:
			return get_level_tag_3exit(cell)
		2:
			return get_level_tag_2exit(cell)
		1:
			return get_level_tag_1exit(cell)
	
	return ""


func get_level_tag_4exit(room : Room) -> String:
	return "room4E" + get_coords_room_in_string(room)


func get_level_tag_3exit(room : Room) -> String:
	return "room3E" + get_direction_number_3exit_room(room) + get_coords_room_in_string(room)


func get_level_tag_2exit(room : Room) -> String:
	return "room2E" + get_direction_number_2exit_room(room) + get_coords_room_in_string(room)


func get_level_tag_1exit(room : Room) -> String:
	return "room1E" + get_direction_number_1exit_room(room) + get_coords_room_in_string(room)


func get_coords_room_in_string(room : Room) -> String:
	return str(room.coords.x) + str(room.coords.y)


func get_direction_number_3exit_room(room : Room) -> String:
	for exit in exits_name:
		if room.exits_test[exit] == null:
			return DIRECTION_OF_3EXIT_ROOM[exit]
	return DIRECTION_OF_3EXIT_ROOM["UP"]


func get_direction_number_2exit_room(room : Room) -> String:
	for exit1 in exits_name:
		for exit2 in exits_name:
			if exit1 == exit2:
				continue
			var value1 = room.exits_test[exit1]
			var value2 = room.exits_test[exit2]
			if not value1 or not value2:
				continue
			return DIRECTION_OF_2EXIT_ROOM[exit1][exit2]
	return DIRECTION_OF_3EXIT_ROOM["UP"]


func get_direction_number_1exit_room(room : Room) -> String:
	for exit in exits_name:
		if room.exits_test[exit] != null:
			return DIRECTION_OF_1EXIT_ROOM[exit]
	return DIRECTION_OF_1EXIT_ROOM["UP"]


func _on_navigate(level_tag : String) -> void:
	var x : int
	var y : int
	var splitted_level_tag = level_tag.split("")
	if "start" in level_tag:
		self.current_room = self.procedure_generator.start
		return
	if "-" in level_tag:
		x = int(splitted_level_tag[-3])
		y = -int(splitted_level_tag[-1])
	else:
		x = int(splitted_level_tag[-2])
		y = int(splitted_level_tag[-1])
	self.current_room = self.dungeon[x][y]
	self.init_exits_of_current_room()
