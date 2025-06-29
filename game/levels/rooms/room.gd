class_name Room extends Node

# main | branch | boss | start
var type_room : String
var init_exit : Vector2i
var coords: Vector2i
var count_exits : int
var exits: Array[Vector2i]


func _init(
	_type_room : String = "ada",
	_init_exit: Vector2i = Vector2i(-1, -1),
	_coords : Vector2i = Vector2i(-1, -1)
	):
	self.count_exits = randi_range(2, 4)
	self._define_exits_for_room()
	self.type_room = _type_room
	self.init_exit = _init_exit
	self.coords = _coords


func _ready():
	if NavigationManager.spawn_door_tag != null:
		on_level_spawn(NavigationManager.spawn_door_tag)


func on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)


func _define_exits_for_room() -> void:
	var exits_variants : Array[Vector2i] = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
	exits_variants.erase(self.init_exit)
	self.exits.append(self.init_exit)

	for i in range(1, self.count_exits):
		var exit = exits_variants[randi_range(0, exits_variants.size() - 1)]
		if exit in exits_variants:
			exits_variants.erase(exit)
			self.exits.append(exit)
