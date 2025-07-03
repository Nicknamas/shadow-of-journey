class_name GameManager extends Node

const PATH_TO_LEVEL = "/root/World/Level"
const NAME_NODE_DOORS = "Doors"
const NAME_NODE_CONSTRUCTOR = "RoomConstuctor"
const exits_name = ["UP", "RIGHT", "DOWN", "LEFT"]

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
	var room_constructor = room.get_node(NAME_NODE_CONSTRUCTOR) as RoomConstuctor
	
	for exit in self.exits_name:
		var current_exit = self.current_room.exits_test[exit]
		if not current_exit:
			continue

		var new_coords = current_exit + self.current_room.coords
		var cell = self.dungeon[new_coords.x][new_coords.y]
		var door = get_door_with_position(exit, doors) as Node
		if cell is Room:
			door.destination_level_tag = get_level_tag(cell)
		else:
			door.queue_free()
			doors.remove_child(door)
	room_constructor.define_room(self.current_room.exits_test)


func get_door_with_position(position : String, doors):
	for door in doors.get_children():
		if door.position_door == position:
			return door


func get_level_tag(cell) -> String:
	if not cell is Room:
		return ""
	
	return "room" + get_coords_room_in_string(cell)


func get_coords_room_in_string(room : Room) -> String:
	return str(room.coords.x) + str(room.coords.y)


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
