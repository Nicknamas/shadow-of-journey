class_name Room extends Node

# main | branch | boss | start
var type_room : String
var init_exit : Vector2i = Vector2i(-1, -1)
var coords: Vector2i
var count_exits : int
var exits_variants : Array[Vector2i] = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
var exits: Array[Vector2i]
var max_x : int
var max_y : int

var exits_test = {
	"UP": null,
	"RIGHT": null,
	"DOWN": null,
	"LEFT": null
}

func _init(
	_max_x : int,
	_max_y : int,
	_type_room : String = "ada",
	_coords : Vector2i = Vector2i(-1, -1)
	):
	self.max_x = _max_x
	self.max_y = _max_y
	self.type_room = _type_room
	self.coords = _coords


func _ready():
	if NavigationManager.spawn_door_tag != null:
		on_level_spawn(NavigationManager.spawn_door_tag)


func on_level_spawn(destination_tag : String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)


func define_init_exit(negative_direction : Vector2i) -> void:
	self.init_exit = negative_direction


func define_exits_for_room() -> void:
	var valid_exits_variants : Array[Vector2i]
	self.insert_exit(self.init_exit)
	if self.init_exit != Vector2i(-1, -1):
		self.count_exits += 1
	for exit in self.exits_variants:
		var new_coords = self.coords + exit
		if self._includes_dungeon_room(new_coords.x, new_coords.y) and self.init_exit != exit:
			valid_exits_variants.append(exit)

	if not valid_exits_variants.size():
		return

	while valid_exits_variants.size():
		var exit = valid_exits_variants[randi_range(0, valid_exits_variants.size() - 1)]
		valid_exits_variants.erase(exit)
		self.insert_exit(exit)
		self.count_exits += 1


func insert_exit(exit: Vector2i) -> void:
	match exit:
		Vector2i.UP:
			exits_test["UP"] = exit
		Vector2i.RIGHT:
			exits_test["RIGHT"] = exit
		Vector2i.DOWN:
			exits_test["DOWN"] = exit
		Vector2i.LEFT:
			exits_test["LEFT"] = exit


func _includes_dungeon_room(current_x, current_y) -> bool:
	return self._includes_dungeon_x(current_x) and self._includes_dungeon_y(current_y)


func _includes_dungeon_x(current_x : int) -> bool:
	return current_x >= 0 and current_x < self.max_x


func _includes_dungeon_y(current_y : int) -> bool:
	return current_y >= 0 and current_y < self.max_y
