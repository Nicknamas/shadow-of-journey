extends Node

const NAME_NODE_CONSTRUCTOR = "RoomConstuctor"
const scene_start = preload("res://game/world/World.tscn")
const scene_room = preload("res://game/levels/dungeon/rooms/Room.tscn")

signal on_trigger_player_spawn
signal on_navigate

var spawn_door_tag
var visited_rooms : Dictionary


func go_to_level(level_tag : String, destination_door_tag : String) -> void:
	var scene_to_load 

	if "start" in level_tag:
		scene_to_load = self.scene_start
	elif "room" in level_tag:
		scene_to_load = self.scene_room

	if "start" in level_tag:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		self.spawn_door_tag = destination_door_tag
		get_tree().change_scene_to_packed(scene_start)
	elif scene_to_load != null:
		var room
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		self.spawn_door_tag = destination_door_tag
		var init_room = scene_to_load.instantiate() as Node
		var level = get_node("/root/World/Level") as Node
		if visited_rooms.has(level_tag):
			print("get from cach")
			room = visited_rooms[level_tag]
		else:
			room = level.get_child(0)
			visited_rooms[level_tag] = room
			var room_constructor = room.get_node(NAME_NODE_CONSTRUCTOR) as RoomConstuctor
			room_constructor.is_cached = true
		level.remove_child(room)
		level.add_child(init_room)
		on_navigate.emit(level_tag)


func trigger_player_spawn(position : Vector2, direction : String) -> void:
	on_trigger_player_spawn.emit(position, direction)
