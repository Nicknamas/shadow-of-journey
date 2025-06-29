class_name GameManager extends Node

@export var start_room : Node

var procedure_generator : ProcedureGeneratorBranchesDungeon
var dungeon : Array
var current_room : Room

func _ready():
	NavigationManager.on_navigate.connect(_on_navigate)
	self.procedure_generator = await ProcedureGeneratorBranchesDungeon.new()
	self.dungeon = self.procedure_generator.get_dungeon()
	self.current_room = self.procedure_generator.start
	self.init_exits_of_current_room()


func init_exits_of_current_room() -> void:
	var level = get_node("/root/World/Level")
	var room = level.get_child(0)
	print(level)
	print(room)
	var doors = room.get_node("Doors") as Node
	var directions = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
	for i in range(4):
		var new_coords = self.current_room.coords + directions[i]
		doors.get_child(i).destination_level_tag = "room" + str(new_coords.x) + str(new_coords.y)


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
